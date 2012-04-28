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

create table ODE_SCHEMA_VERSION (VERSION integer);
insert into ODE_SCHEMA_VERSION values (6);
-- Apache ODE - SimpleScheduler Database Schema
--
-- Apache Derby scripts by Maciej Szefler.
--
--

DROP TABLE ode_job;

CREATE TABLE ode_job (
  jobid VARCHAR(64)  NOT NULL,
  ts number(37)  NOT NULL,
  nodeid varchar(64),
  scheduled int  NOT NULL,
  transacted int  NOT NULL,

  instanceId number(37),
  mexId varchar(255),
  processId varchar(255),
  type varchar(255),
  channel varchar(255),
  correlatorId varchar(255),
  correlationKeySet varchar(255),
  retryCount int,
  inMem int,
  detailsExt blob,

  PRIMARY KEY(jobid));

CREATE INDEX IDX_ODE_JOB_TS ON ode_job(ts);
CREATE INDEX IDX_ODE_JOB_NODEID ON ode_job(nodeid);


CREATE TABLE TASK_ATTACHMENT (ATTACHMENT_ID BIGINT NOT NULL, MESSAGE_EXCHANGE_ID VARCHAR(255), PRIMARY KEY (ATTACHMENT_ID));
CREATE TABLE ODE_ACTIVITY_RECOVERY (ID NUMBER NOT NULL, ACTIONS VARCHAR2(255), ACTIVITY_ID NUMBER, CHANNEL VARCHAR2(255), DATE_TIME TIMESTAMP, DETAILS CLOB, INSTANCE_ID NUMBER, REASON VARCHAR2(255), RETRIES NUMBER, PRIMARY KEY (ID));
CREATE TABLE ODE_CORRELATION_SET (CORRELATION_SET_ID NUMBER NOT NULL, CORRELATION_KEY VARCHAR2(255), NAME VARCHAR2(255), SCOPE_ID NUMBER, PRIMARY KEY (CORRELATION_SET_ID));
CREATE TABLE ODE_CORRELATOR (CORRELATOR_ID NUMBER NOT NULL, CORRELATOR_KEY VARCHAR2(255), PROC_ID NUMBER, PRIMARY KEY (CORRELATOR_ID));
CREATE TABLE ODE_CORSET_PROP (ID NUMBER NOT NULL, CORRSET_ID NUMBER, PROP_KEY VARCHAR2(255), PROP_VALUE VARCHAR2(255), PRIMARY KEY (ID));
CREATE TABLE ODE_EVENT (EVENT_ID NUMBER NOT NULL, DETAIL VARCHAR2(255), DATA BLOB, SCOPE_ID NUMBER, TSTAMP TIMESTAMP, TYPE VARCHAR2(255), INSTANCE_ID NUMBER, PROCESS_ID NUMBER, PRIMARY KEY (EVENT_ID));
CREATE TABLE ODE_FAULT (FAULT_ID NUMBER NOT NULL, ACTIVITY_ID NUMBER, DATA CLOB, MESSAGE VARCHAR2(4000), LINE_NUMBER NUMBER, NAME VARCHAR2(255), PRIMARY KEY (FAULT_ID));
CREATE TABLE ODE_MESSAGE (MESSAGE_ID NUMBER NOT NULL, DATA CLOB, HEADER CLOB, TYPE VARCHAR2(255), MESSAGE_EXCHANGE_ID VARCHAR2(255), PRIMARY KEY (MESSAGE_ID));
CREATE TABLE ODE_MESSAGE_EXCHANGE (MESSAGE_EXCHANGE_ID VARCHAR2(255) NOT NULL, CALLEE VARCHAR2(255), CHANNEL VARCHAR2(255), CORRELATION_ID VARCHAR2(255), CORRELATION_KEYS VARCHAR2(255), CORRELATION_STATUS VARCHAR2(255), CREATE_TIME TIMESTAMP, DIRECTION NUMBER, EPR CLOB, FAULT VARCHAR2(255), FAULT_EXPLANATION VARCHAR2(255), OPERATION VARCHAR2(255), PARTNER_LINK_MODEL_ID NUMBER, PATTERN VARCHAR2(255), PIPED_ID VARCHAR2(255), PORT_TYPE VARCHAR2(255), PROPAGATE_TRANS NUMBER, STATUS VARCHAR2(255), SUBSCRIBER_COUNT NUMBER, CORR_ID NUMBER, PARTNER_LINK_ID NUMBER, PROCESS_ID NUMBER, PROCESS_INSTANCE_ID NUMBER, REQUEST_MESSAGE_ID NUMBER, RESPONSE_MESSAGE_ID NUMBER, PRIMARY KEY (MESSAGE_EXCHANGE_ID));
CREATE TABLE ODE_MESSAGE_ROUTE (MESSAGE_ROUTE_ID NUMBER NOT NULL, CORRELATION_KEY VARCHAR2(255), GROUP_ID VARCHAR2(255), ROUTE_INDEX NUMBER, PROCESS_INSTANCE_ID NUMBER, ROUTE_POLICY VARCHAR2(16), CORR_ID NUMBER, PRIMARY KEY (MESSAGE_ROUTE_ID));
CREATE TABLE ODE_MEX_PROP (ID NUMBER NOT NULL, MEX_ID VARCHAR2(255), PROP_KEY VARCHAR2(255), PROP_VALUE VARCHAR2(2000), PRIMARY KEY (ID));
CREATE TABLE ODE_PARTNER_LINK (PARTNER_LINK_ID NUMBER NOT NULL, MY_EPR CLOB, MY_ROLE_NAME VARCHAR2(255), MY_ROLE_SERVICE_NAME VARCHAR2(255), MY_SESSION_ID VARCHAR2(255), PARTNER_EPR CLOB, PARTNER_LINK_MODEL_ID NUMBER, PARTNER_LINK_NAME VARCHAR2(255), PARTNER_ROLE_NAME VARCHAR2(255), PARTNER_SESSION_ID VARCHAR2(255), SCOPE_ID NUMBER, PRIMARY KEY (PARTNER_LINK_ID));
CREATE TABLE ODE_PROCESS (ID NUMBER NOT NULL, GUID VARCHAR2(255), PROCESS_ID VARCHAR2(255), PROCESS_TYPE VARCHAR2(255), VERSION NUMBER, PRIMARY KEY (ID));
CREATE TABLE ODE_PROCESS_INSTANCE (ID NUMBER NOT NULL, DATE_CREATED TIMESTAMP, EXECUTION_STATE BLOB, FAULT_ID NUMBER, LAST_ACTIVE_TIME TIMESTAMP, LAST_RECOVERY_DATE TIMESTAMP, PREVIOUS_STATE NUMBER, SEQUENCE NUMBER, INSTANCE_STATE NUMBER, INSTANTIATING_CORRELATOR_ID NUMBER, PROCESS_ID NUMBER, ROOT_SCOPE_ID NUMBER, PRIMARY KEY (ID));
CREATE TABLE ODE_SCOPE (SCOPE_ID NUMBER NOT NULL, MODEL_ID NUMBER, SCOPE_NAME VARCHAR2(255), SCOPE_STATE VARCHAR2(255), PROCESS_INSTANCE_ID NUMBER, PARENT_SCOPE_ID NUMBER, PRIMARY KEY (SCOPE_ID));
CREATE TABLE ODE_XML_DATA (XML_DATA_ID NUMBER NOT NULL, DATA CLOB, IS_SIMPLE_TYPE NUMBER, NAME VARCHAR2(255), SCOPE_ID NUMBER, PRIMARY KEY (XML_DATA_ID));
CREATE TABLE ODE_XML_DATA_PROP (ID NUMBER NOT NULL, XML_DATA_ID NUMBER, PROP_KEY VARCHAR2(255), PROP_VALUE VARCHAR2(255), PRIMARY KEY (ID));
CREATE TABLE OPENJPA_SEQUENCE_TABLE (ID NUMBER NOT NULL, SEQUENCE_VALUE NUMBER, PRIMARY KEY (ID));
CREATE TABLE STORE_DU (NAME VARCHAR2(255) NOT NULL, DEPLOYDT TIMESTAMP, DEPLOYER VARCHAR2(255), DIR VARCHAR2(255), PRIMARY KEY (NAME));
CREATE TABLE STORE_PROCESS (PID VARCHAR2(255) NOT NULL, STATE VARCHAR2(255), TYPE VARCHAR2(255), VERSION NUMBER, DU VARCHAR2(255), PRIMARY KEY (PID));
CREATE TABLE STORE_PROCESS_PROP (id NUMBER NOT NULL, PROP_KEY VARCHAR2(255), PROP_VAL VARCHAR2(255), PRIMARY KEY (id));
CREATE TABLE STORE_PROC_TO_PROP (PROCESSCONFDAOIMPL_PID VARCHAR2(255), ELEMENT_ID NUMBER);
CREATE TABLE STORE_VERSIONS (id NUMBER NOT NULL, VERSION NUMBER, PRIMARY KEY (id));
CREATE INDEX I_D_TASK_ATTACMENT ON TASK_ATTACHMENT (MESSAGE_EXCHANGE_ID);
CREATE INDEX I_D_CTVRY_INSTANCE ON ODE_ACTIVITY_RECOVERY (INSTANCE_ID);
CREATE INDEX I_D_CR_ST_SCOPE ON ODE_CORRELATION_SET (SCOPE_ID);
CREATE INDEX I_D_CRLTR_PROCESS ON ODE_CORRELATOR (PROC_ID);
CREATE INDEX I_D_CRPRP_CORRSET ON ODE_CORSET_PROP (CORRSET_ID);
CREATE INDEX I_OD_VENT_INSTANCE ON ODE_EVENT (INSTANCE_ID);
CREATE INDEX I_OD_VENT_PROCESS ON ODE_EVENT (PROCESS_ID);
CREATE INDEX I_OD_MSSG_MESSAGEEXCHANGE ON ODE_MESSAGE (MESSAGE_EXCHANGE_ID);
CREATE INDEX I_D_MSHNG_CORRELATOR ON ODE_MESSAGE_EXCHANGE (CORR_ID);
CREATE INDEX I_D_MSHNG_PARTNERLINK ON ODE_MESSAGE_EXCHANGE (PARTNER_LINK_ID);
CREATE INDEX I_D_MSHNG_PROCESS ON ODE_MESSAGE_EXCHANGE (PROCESS_ID);
CREATE INDEX I_D_MSHNG_PROCESSINST ON ODE_MESSAGE_EXCHANGE (PROCESS_INSTANCE_ID);
CREATE INDEX I_D_MSHNG_REQUEST ON ODE_MESSAGE_EXCHANGE (REQUEST_MESSAGE_ID);
CREATE INDEX I_D_MSHNG_RESPONSE ON ODE_MESSAGE_EXCHANGE (RESPONSE_MESSAGE_ID);
CREATE INDEX I_D_MS_RT_CORRELATOR ON ODE_MESSAGE_ROUTE (CORR_ID);
CREATE INDEX I_D_MS_RT_PROCESSINST ON ODE_MESSAGE_ROUTE (PROCESS_INSTANCE_ID);
CREATE INDEX I_D_MXPRP_MEX ON ODE_MEX_PROP (MEX_ID);
CREATE INDEX I_D_PRLNK_SCOPE ON ODE_PARTNER_LINK (SCOPE_ID);
CREATE INDEX I_D_PRTNC_FAULT ON ODE_PROCESS_INSTANCE (FAULT_ID);
CREATE INDEX I_D_PRTNC_INSTANTIATINGCORRELA ON ODE_PROCESS_INSTANCE (INSTANTIATING_CORRELATOR_ID);
CREATE INDEX I_D_PRTNC_PROCESS ON ODE_PROCESS_INSTANCE (PROCESS_ID);
CREATE INDEX I_D_PRTNC_ROOTSCOPE ON ODE_PROCESS_INSTANCE (ROOT_SCOPE_ID);
CREATE INDEX I_OD_SCOP_PARENTSCOPE ON ODE_SCOPE (PARENT_SCOPE_ID);
CREATE INDEX I_OD_SCOP_PROCESSINSTANCE ON ODE_SCOPE (PROCESS_INSTANCE_ID);
CREATE INDEX I_D_XM_DT_SCOPE ON ODE_XML_DATA (SCOPE_ID);
CREATE INDEX I_D_XMPRP_XMLDATA ON ODE_XML_DATA_PROP (XML_DATA_ID);
CREATE INDEX I_STR_CSS_DU ON STORE_PROCESS (DU);
CREATE INDEX I_STR_PRP_ELEMENT ON STORE_PROC_TO_PROP (ELEMENT_ID);
CREATE INDEX I_STR_PRP_PROCESSCONFDAOIMPL_P ON STORE_PROC_TO_PROP (PROCESSCONFDAOIMPL_PID);
