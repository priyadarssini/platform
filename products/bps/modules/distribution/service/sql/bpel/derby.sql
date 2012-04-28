--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the License is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
-- KIND, either express or implied.  See the License for the
-- specific language governing permissions and limitations
-- under the License.
--
 
CREATE TABLE TASK_ATTACHMENT (ATTACHMENT_ID BIGINT NOT NULL, MESSAGE_EXCHANGE_ID VARCHAR(255), PRIMARY KEY (ATTACHMENT_ID));
CREATE TABLE ODE_ACTIVITY_RECOVERY (ID BIGINT NOT NULL, ACTIONS VARCHAR(255), ACTIVITY_ID BIGINT, CHANNEL VARCHAR(255), DATE_TIME TIMESTAMP, DETAILS CLOB, INSTANCE_ID BIGINT, REASON VARCHAR(255), RETRIES INTEGER, PRIMARY KEY (ID));
CREATE TABLE ODE_CORRELATION_SET (CORRELATION_SET_ID BIGINT NOT NULL, CORRELATION_KEY VARCHAR(255), NAME VARCHAR(255), SCOPE_ID BIGINT, PRIMARY KEY (CORRELATION_SET_ID));
CREATE TABLE ODE_CORRELATOR (CORRELATOR_ID BIGINT NOT NULL, CORRELATOR_KEY VARCHAR(255), PROC_ID BIGINT, PRIMARY KEY (CORRELATOR_ID));
CREATE TABLE ODE_CORSET_PROP (ID BIGINT NOT NULL, CORRSET_ID BIGINT, PROP_KEY VARCHAR(255), PROP_VALUE VARCHAR(255), PRIMARY KEY (ID));
CREATE TABLE ODE_EVENT (EVENT_ID BIGINT NOT NULL, DETAIL VARCHAR(255), DATA BLOB, SCOPE_ID BIGINT, TSTAMP TIMESTAMP, TYPE VARCHAR(255), INSTANCE_ID BIGINT, PROCESS_ID BIGINT, PRIMARY KEY (EVENT_ID));
CREATE TABLE ODE_FAULT (FAULT_ID BIGINT NOT NULL, ACTIVITY_ID INTEGER, DATA CLOB, MESSAGE VARCHAR(4000), LINE_NUMBER INTEGER, NAME VARCHAR(255), PRIMARY KEY (FAULT_ID));
CREATE TABLE ODE_MESSAGE (MESSAGE_ID BIGINT NOT NULL, DATA CLOB, HEADER CLOB, TYPE VARCHAR(255), PRIMARY KEY (MESSAGE_ID));
CREATE TABLE ODE_MESSAGE_EXCHANGE (MESSAGE_EXCHANGE_ID VARCHAR(255) NOT NULL, ACK_TYPE VARCHAR(255), CALLEE VARCHAR(255), CHANNEL VARCHAR(255), CORRELATION_ID VARCHAR(255), CORRELATION_KEYS VARCHAR(255), CORRELATION_STATUS VARCHAR(255), CREATE_TIME TIMESTAMP NOT NULL, DIRECTION INTEGER NOT NULL, EPR CLOB, FAILURE_TYPE VARCHAR(255), FAULT VARCHAR(255), FAULT_EXPLANATION VARCHAR(255), ISTYLE VARCHAR(255), OPERATION VARCHAR(255) NOT NULL, PARTNER_LINK_MODEL_ID INTEGER NOT NULL, PATTERN VARCHAR(255) NOT NULL, PIPED_ID VARCHAR(255), PIPED_PID VARCHAR(255), PORT_TYPE VARCHAR(255), PROPAGATE_TRANS SMALLINT, STATUS VARCHAR(255), TIMEOUT BIGINT, CORRELATOR BIGINT, PLINK BIGINT, PROCESS BIGINT, INSTANCE BIGINT, REQUEST BIGINT, RESPONSE BIGINT, PRIMARY KEY (MESSAGE_EXCHANGE_ID));
CREATE TABLE ODE_MESSAGE_ROUTE (MESSAGE_ROUTE_ID BIGINT NOT NULL, CORRELATION_KEY VARCHAR(255), GROUP_ID VARCHAR(255), ROUTE_INDEX INTEGER, PROCESS_INSTANCE_ID INTEGER, CORR_ID BIGINT, PRIMARY KEY (MESSAGE_ROUTE_ID));
CREATE TABLE ODE_MEX_PROP (ID BIGINT NOT NULL, MEX_ID VARCHAR(255), PROP_KEY VARCHAR(255), PROP_VALUE VARCHAR(2000), PRIMARY KEY (ID));
CREATE TABLE ODE_PARTNER_LINK (PARTNER_LINK_ID BIGINT NOT NULL, MY_EPR CLOB, MY_ROLE_NAME VARCHAR(255), MY_ROLE_SERVICE_NAME VARCHAR(255), MY_SESSION_ID VARCHAR(255), PARTNER_EPR CLOB, PARTNER_LINK_MODEL_ID INTEGER, PARTNER_LINK_NAME VARCHAR(255), PARTNER_ROLE_NAME VARCHAR(255), PARTNER_SESSION_ID VARCHAR(255), SCOPE_ID BIGINT, PRIMARY KEY (PARTNER_LINK_ID));
CREATE TABLE ODE_PROCESS (ID BIGINT NOT NULL, GUID VARCHAR(255), PROCESS_ID VARCHAR(255), PROCESS_TYPE VARCHAR(255), VERSION BIGINT, PRIMARY KEY (ID));
CREATE TABLE ODE_PROCESS_INSTANCE (ID BIGINT NOT NULL, DATE_CREATED TIMESTAMP, EXEC_STATE_COUNTER INTEGER, EXECUTION_STATE BLOB, FAULT_ID BIGINT, LAST_ACTIVE_TIME TIMESTAMP, LAST_RECOVERY_DATE TIMESTAMP, PREVIOUS_STATE SMALLINT, SEQUENCE BIGINT, INSTANCE_STATE SMALLINT, INSTANTIATING_CORRELATOR_ID BIGINT, PROCESS_ID BIGINT, ROOT_SCOPE_ID BIGINT, PRIMARY KEY (ID));
CREATE TABLE ODE_SCOPE (SCOPE_ID BIGINT NOT NULL, MODEL_ID INTEGER, SCOPE_NAME VARCHAR(255), SCOPE_STATE VARCHAR(255), PARENT_SCOPE_ID BIGINT, PROCESS_INSTANCE_ID BIGINT, PRIMARY KEY (SCOPE_ID));
CREATE TABLE ODE_XML_DATA (XML_DATA_ID BIGINT NOT NULL, DATA CLOB, IS_SIMPLE_TYPE SMALLINT, NAME VARCHAR(255), SCOPE_ID BIGINT, PRIMARY KEY (XML_DATA_ID));
CREATE TABLE ODE_XML_DATA_PROP (ID BIGINT NOT NULL, XML_DATA_ID BIGINT, PROP_KEY VARCHAR(255), PROP_VALUE VARCHAR(255), PRIMARY KEY (ID));
CREATE TABLE OPENJPA_SEQUENCE_TABLE (ID SMALLINT NOT NULL, SEQUENCE_VALUE BIGINT, PRIMARY KEY (ID));
CREATE TABLE STORE_DU (NAME VARCHAR(255) NOT NULL, DEPLOYDT TIMESTAMP, DEPLOYER VARCHAR(255), DIR VARCHAR(255), PRIMARY KEY (NAME));
CREATE TABLE STORE_PROCESS (PID VARCHAR(255) NOT NULL, STATE VARCHAR(255), TYPE VARCHAR(255), VERSION BIGINT, DU VARCHAR(255), PRIMARY KEY (PID));
CREATE TABLE STORE_PROCESS_PROP (id BIGINT NOT NULL, PROP_KEY VARCHAR(255), PROP_VAL VARCHAR(255), PRIMARY KEY (id));
CREATE TABLE STORE_PROC_TO_PROP (ProcessConfDaoImpl_PID VARCHAR(255), element_id BIGINT);
CREATE TABLE STORE_VERSIONS (id BIGINT NOT NULL, VERSION BIGINT, PRIMARY KEY (id));
CREATE INDEX I_D_TASK_ATTACMENT ON TASK_ATTACHMENT (MESSAGE_EXCHANGE_ID);
CREATE INDEX I_D_CTVRY_INSTANCE ON ODE_ACTIVITY_RECOVERY (INSTANCE_ID);
CREATE INDEX I_D_CR_ST_SCOPE ON ODE_CORRELATION_SET (SCOPE_ID);
CREATE INDEX I_D_CRLTR_PROCESS ON ODE_CORRELATOR (PROC_ID);
CREATE INDEX I_D_CRPRP_CORRSET ON ODE_CORSET_PROP (CORRSET_ID);
CREATE INDEX I_OD_VENT_INSTANCE ON ODE_EVENT (INSTANCE_ID);
CREATE INDEX I_OD_VENT_PROCESS ON ODE_EVENT (PROCESS_ID);
CREATE INDEX I_D_MSHNG_CORRELAT ON ODE_MESSAGE_EXCHANGE (CORRELATOR);
CREATE INDEX I_D_MSHNG_PARTNERL ON ODE_MESSAGE_EXCHANGE (PLINK);
CREATE INDEX I_D_MSHNG_PROCESS ON ODE_MESSAGE_EXCHANGE (PROCESS);
CREATE INDEX I_D_MSHNG_PROCESSI ON ODE_MESSAGE_EXCHANGE (INSTANCE);
CREATE INDEX I_D_MSHNG_REQUEST ON ODE_MESSAGE_EXCHANGE (REQUEST);
CREATE INDEX I_D_MSHNG_RESPONSE ON ODE_MESSAGE_EXCHANGE (RESPONSE);
CREATE INDEX I_D_MS_RT_CORRELAT ON ODE_MESSAGE_ROUTE (CORR_ID);
CREATE INDEX I_D_MS_RT_PROCESSI ON ODE_MESSAGE_ROUTE (PROCESS_INSTANCE_ID);
CREATE INDEX I_D_MXPRP_MEX ON ODE_MEX_PROP (MEX_ID);
CREATE INDEX I_D_PRLNK_SCOPE ON ODE_PARTNER_LINK (SCOPE_ID);
CREATE INDEX I_D_PRTNC_FAULT ON ODE_PROCESS_INSTANCE (FAULT_ID);
CREATE INDEX I_D_PRTNC_INSTANTI ON ODE_PROCESS_INSTANCE (INSTANTIATING_CORRELATOR_ID);
CREATE INDEX I_D_PRTNC_PROCESS ON ODE_PROCESS_INSTANCE (PROCESS_ID);
CREATE INDEX I_D_PRTNC_ROOTSCOP ON ODE_PROCESS_INSTANCE (ROOT_SCOPE_ID);
CREATE INDEX I_OD_SCOP_PARENTSC ON ODE_SCOPE (PARENT_SCOPE_ID);
CREATE INDEX I_OD_SCOP_PROCESSI ON ODE_SCOPE (PROCESS_INSTANCE_ID);
CREATE INDEX I_D_XM_DT_SCOPE ON ODE_XML_DATA (SCOPE_ID);
CREATE INDEX I_D_XMPRP_XMLDATA ON ODE_XML_DATA_PROP (XML_DATA_ID);
CREATE INDEX I_STR_CSS_DU ON STORE_PROCESS (DU);
CREATE INDEX I_STR_PRP_ELEMENT ON STORE_PROC_TO_PROP (element_id);
CREATE INDEX I_STR_PRP_PROCESSC ON STORE_PROC_TO_PROP (ProcessConfDaoImpl_PID);
-- Apache ODE - SimpleScheduler Database Schema
-- 
-- Apache Derby scripts by Maciej Szefler.
-- 
-- 

CREATE TABLE ode_job (
  jobid CHAR(64)  NOT NULL DEFAULT '',
  ts BIGINT  NOT NULL DEFAULT 0,
  nodeid char(64),
  scheduled int  NOT NULL DEFAULT 0,
  transacted int  NOT NULL DEFAULT 0,
  details blob(4096),
  PRIMARY KEY(jobid));

CREATE INDEX IDX_ODE_JOB_TS ON ode_job(ts);
CREATE INDEX IDX_ODE_JOB_NODEID ON ode_job(nodeid);


