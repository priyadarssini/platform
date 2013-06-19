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

package org.wso2.carbon.transport.adaptor.wsevent.local.internal.ds;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.osgi.service.component.ComponentContext;
import org.wso2.carbon.event.core.EventBroker;
import org.wso2.carbon.transport.adaptor.core.TransportAdaptorRegistrationService;
import org.wso2.carbon.transport.adaptor.core.exception.TransportAdaptorConfigException;
import org.wso2.carbon.transport.adaptor.wsevent.local.WSEventLocalTransportAdaptorFactory;


/**
 * @scr.component name="WSEventLocalReceiverTransportAdaptorService.component" immediate="true"
 * @scr.reference name="transport.adaptor.service"
 * interface="org.wso2.carbon.transport.adaptor.core.TransportAdaptorRegistrationService" cardinality="1..1"
 * policy="dynamic" bind="setTransportAdaptorRegistrationService" unbind="unSetTransportAdaptorRegistrationService"
 * @scr.reference name="eventbroker.service"
 * interface="org.wso2.carbon.event.core.EventBroker" cardinality="1..1"
 * policy="dynamic" bind="setWSEventTransportAdaptorService" unbind="unSetWSEventTransportAdaptorService"
 */


public class WSEventLocalTransportAdaptorServiceDS {

    private static final Log log = LogFactory.getLog(WSEventLocalTransportAdaptorServiceDS.class);

    /**
     * initialize the agent service here service here.
     *
     * @param context
     */
    protected void activate(ComponentContext context) {

        try {
            WSEventLocalTransportAdaptorServiceValueHolder.getTransportRegistrationService().registerTransportAdaptor(WSEventLocalTransportAdaptorFactory.class.getName());
            log.info("Successfully deployed the WSEventLocal transport service");
        } catch (RuntimeException e) {
            log.error("Can not create transport service ", e);
        } catch (TransportAdaptorConfigException e) {
            log.error("Transport adaptor configuration error occurred ");
        }
    }

    protected void setTransportAdaptorRegistrationService(
            TransportAdaptorRegistrationService transportAdaptorRegistrationService) {
        WSEventLocalTransportAdaptorServiceValueHolder.registerTransportRegistrationService(transportAdaptorRegistrationService);
    }

    protected void unSetTransportAdaptorRegistrationService(
            TransportAdaptorRegistrationService transportAdaptorRegistrationServicee) {

    }

    protected void setWSEventTransportAdaptorService(EventBroker eventBroker) {
        WSEventLocalTransportAdaptorServiceValueHolder.registerEventBroker(eventBroker);
    }

    protected void unSetWSEventTransportAdaptorService(EventBroker eventBroker) {

    }

}