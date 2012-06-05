/*
 *  Copyright WSO2 Inc.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package org.wso2.carbon.apimgt.perf.client;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpRequestRetryHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.scheme.SocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.protocol.HttpContext;

import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.atomic.AtomicInteger;

public class HttpLoadTestClient {

    private static AtomicInteger counter = new AtomicInteger(0);

    private static int PIT_STOP = 1000;

    public static void main(String[] args) {
        int concurrency = 50;
        int count = 1000;
        String url = "http://localhost:8280/ticker/1.0.0?symbol=IBM";


        ClientWorker[] workers = new ClientWorker[concurrency];
        for (int i = 0; i < concurrency; i++) {
            workers[i] = new ClientWorker(count, url);
            workers[i].start();
        }

        int success = 0;
        int failures = 0;
        long totalTime = 0L;
        for (int i = 0; i < concurrency; i++) {
            try {
                workers[i].join();
            } catch (InterruptedException ignored) {

            }
            success += workers[i].getSuccess();
            failures += workers[i].getFailures();
            totalTime += workers[i].getTimeElapsed();
        }

        int total = concurrency * count;
        double time = totalTime/1000.0;
        System.out.println("\n\nSuccessful invocations: " + success + "/" + total);
        System.out.println("Failed invocations: " + failures + "/" + total);
        if (time > 0) {
            System.out.println("Throughput: " + (total/time) + " TPS");
        }
    }

    private static class ClientWorker extends Thread {

        private int count;
        private String url;

        private int success = 0;
        private int failures = 0;

        private int rollingCounter = 0;
        private long timeElapsed;

        public ClientWorker(int count, String url) {
            this.count = count;
            this.url = url;
        }

        @Override
        public void run() {
            long t1 = System.currentTimeMillis();
            SchemeRegistry supportedSchemes = new SchemeRegistry();
            SocketFactory sf = PlainSocketFactory.getSocketFactory();
            supportedSchemes.register(new Scheme("http", sf, 80));
            ThreadSafeClientConnManager connManager = new ThreadSafeClientConnManager(supportedSchemes);
            connManager.setDefaultMaxPerRoute(1000);
            DefaultHttpClient client = new DefaultHttpClient(connManager);
            HttpParams params = client.getParams();
            HttpConnectionParams.setConnectionTimeout(params, 30000);
            HttpConnectionParams.setSoTimeout(params, 30000);
            client.setHttpRequestRetryHandler(new HttpRequestRetryHandler() {
                public boolean retryRequest(IOException e, int i, HttpContext httpContext) {
                    return false;
                }
            });

            for (int i = 0; i < count; i++) {
                HttpUriRequest request = new HttpGet(url);
                request.addHeader("Authorization", "Bearer " + getNextKey());
                try {
                    HttpResponse response = client.execute(request);
                    int statusCode = response.getStatusLine().getStatusCode();
                    HttpEntity entity = response.getEntity();
                    if (entity != null) {
                        InputStream in = entity.getContent();
                        try {
                            byte[] data = new byte[8096];
                            while ((in.read(data)) != -1);
                        } finally {
                            in.close();
                        }
                    }
                    if (statusCode == 200) {
                        success++;
                    } else {
                        failures++;
                    }
                } catch (IOException e) {
                    System.err.println("I/O error while executing request: " + e.getMessage());
                    e.printStackTrace();
                    failures++;
                } finally {
                    int current = counter.incrementAndGet();
                    if (current % PIT_STOP == 0) {
                        System.out.println("Completed " + current + " requests");
                    }
                }
            }
            long t2 = System.currentTimeMillis();
            timeElapsed = t2 - t1;
        }

        public long getTimeElapsed() {
            return timeElapsed;
        }

        public int getSuccess() {
            return success;
        }

        public int getFailures() {
            return failures;
        }

        private String getNextKey() {
            if (rollingCounter == 10000) {
                rollingCounter = 0;
            }
            return "9nEQnijLZ0Gi0gZ6a3pZIC" + rollingCounter++;
        }
    }
}
