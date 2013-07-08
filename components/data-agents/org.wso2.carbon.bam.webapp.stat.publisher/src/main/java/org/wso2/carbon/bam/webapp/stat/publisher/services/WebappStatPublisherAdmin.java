/*
 * Copyright 2004,2005 The Apache Software Foundation.
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
package org.wso2.carbon.bam.webapp.stat.publisher.services;


import org.wso2.carbon.bam.webapp.stat.publisher.conf.ServiceEventingConfigData;
import org.wso2.carbon.bam.webapp.stat.publisher.conf.RegistryPersistenceManager;
import org.wso2.carbon.bam.webapp.stat.publisher.util.WebappConfig;
import org.wso2.carbon.bam.webapp.stat.publisher.util.WebappStatisticsPublisherConstants;
import org.wso2.carbon.base.ServerConfiguration;
import org.wso2.carbon.context.CarbonContext;
import org.wso2.carbon.core.AbstractAdmin;
import org.wso2.carbon.webapp.statistics.ComputeData;
import org.wso2.carbon.webapp.statistics.data.StatisticData;

public class WebappStatPublisherAdmin extends AbstractAdmin {
    private RegistryPersistenceManager registryPersistenceManager;

    public WebappStatPublisherAdmin() {
        registryPersistenceManager = new RegistryPersistenceManager();
    }

    public void configureEventing(ServiceEventingConfigData eventingConfigData) throws Exception {
        registryPersistenceManager.update(eventingConfigData);
    }

    public ServiceEventingConfigData getEventingConfigData() {
        return registryPersistenceManager.getEventingConfigData();
    }

    public boolean isCloudDeployment(){
        String[] cloudDeploy = ServerConfiguration.getInstance().
                getProperties(WebappStatisticsPublisherConstants.CLOUD_DEPLOYMENT_PROP);
        return null != cloudDeploy && Boolean.parseBoolean(cloudDeploy[cloudDeploy.length - 1]);
    }

    public String getServerConfigBAMServerURL(){
        String[] bamServerUrl =
                ServerConfiguration.getInstance().
                        getProperties(WebappStatisticsPublisherConstants.SERVER_CONFIG_BAM_URL);
        if(null != bamServerUrl){
           return bamServerUrl[bamServerUrl.length-1];
        }else {
           return WebappStatisticsPublisherConstants.DEFAULT_BAM_SERVER_URL;
        }
    }

    public void setWebappConfiguration(String webappName, int value){
        WebappConfig webappConfig = new WebappConfig();
        webappConfig.setWebappConfigData(webappName,value);
    }

    public boolean getWebappConfiguration(String webappName){
        WebappConfig webappConfig = new WebappConfig();
        return  webappConfig.getWebappConfigData(webappName);

    }

    public StatisticData getWebappRelatedData(String webAppName) {
        try {

            int tenantId = CarbonContext.getCurrentContext().getTenantId();

            StatisticData statisticData = ComputeData.map.get(tenantId).get(webAppName);
            return statisticData;
        } catch (Exception e) {
            return null;
        }
    }
}
