/*
 * Copyright 2006 The Apache Software Foundation.
 * Copyright 2006 International Business Machines Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.sandesha2.security;

import java.io.File;

import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.ConfigurationContext;
import org.apache.axis2.context.ConfigurationContextFactory;
import org.apache.sandesha2.Sandesha2Constants;
import org.apache.sandesha2.SandeshaTestCase;
import org.apache.sandesha2.client.SandeshaClient;
import org.apache.sandesha2.client.SandeshaClientConstants;
import org.apache.sandesha2.client.SequenceReport;

/**
 * Low-level testcases for the Security handling. This test mostly checks that the code can
 * read and write the SecurityTokenReference elements that we expect to find within the create
 * sequence messgaes.
 */
public class SecurityTest extends SandeshaTestCase {

	public SecurityTest(String name) {
		super(name);
	}
	
	public void setUp () throws Exception {
		super.setUp();

		String repoPath = "target" + File.separator + "repos" + File.separator + "secure-server";
		String axis2_xml = repoPath + File.separator + "server_axis2.xml";

		startServer(repoPath, axis2_xml);
	}
	
	// Test the create sequence flow for the 2 spec versions
	public void testCreateSequence()
	throws Exception
	{
		createSequence(Sandesha2Constants.SPEC_VERSIONS.v1_0);
		createSequence(Sandesha2Constants.SPEC_VERSIONS.v1_1);
	}

	// Check that we can send a create sequence that includes a token reference.
	public void createSequence(String spec) throws Exception {
		String to = "http://127.0.0.1:" + serverPort + "/axis2/services/RMSampleService";

		String repoPath = "target" + File.separator + "repos" + File.separator + "secure-client";
		String axis2_xml = repoPath + File.separator + "client_axis2.xml";
		
		ConfigurationContext configContext = ConfigurationContextFactory.createConfigurationContextFromFileSystem(repoPath,axis2_xml);
		ServiceClient serviceClient = new ServiceClient (configContext,null);
		
//		String sequenceKey = SandeshaUtil.getUUID();

		Options clientOptions = new Options ();

		clientOptions.setTo(new EndpointReference (to));

//		clientOptions.setProperty(SandeshaClientConstants.SEQUENCE_KEY,sequenceKey);
		
		clientOptions.setProperty(SandeshaClientConstants.RM_SPEC_VERSION, spec);
		serviceClient.setOptions(clientOptions);
		
		String sequenceKey = SandeshaClient.createSequence(serviceClient,false);
		clientOptions.setProperty(SandeshaClientConstants.SEQUENCE_KEY, sequenceKey);
		
		long limit = System.currentTimeMillis() + waitTime;
		Error lastError = null;
		while(System.currentTimeMillis() < limit) {
			Thread.sleep(tickTime); // Try the assertions each tick interval, until they pass or we time out
			
			try {
				SequenceReport sequenceReport = SandeshaClient.getOutgoingSequenceReport(serviceClient);
				assertNotNull(sequenceReport);
				assertTrue(sequenceReport.isSecureSequence());

				lastError = null;
				break;
			} catch(Error e) {
				lastError = e;
			}
		}

		if(lastError != null) throw lastError;

		configContext.getListenerManager().stop();
		serviceClient.cleanup();
	}

}
