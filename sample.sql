BEGIN TRANSACTION;
/*
=========================================================
    Drop Tables
=========================================================
*/
-- 31. TBL_SfisStation
DROP TABLE IF EXISTS TBL_SfisStation;
DROP SEQUENCE IF EXISTS TBL_SfisStation_id;

-- 30. TBL_DIPChipBinding
DROP TABLE IF EXISTS TBL_DIPChipBinding;
DROP SEQUENCE IF EXISTS TBL_DIPChipBinding_id;

-- 29. TBL_SystemLog
DROP TABLE IF EXISTS TBL_SystemLog;

-- 28. TBL_SystemEvent
DROP TABLE IF EXISTS TBL_SystemEvent;
DROP SEQUENCE IF EXISTS TBL_SystemEvent_id;

-- 27. TBL_SystemEventType
DROP TABLE IF EXISTS TBL_SystemEventType;
DROP SEQUENCE IF EXISTS TBL_SystemEventType_id;

-- 26. TBL_StationFlow
DROP TABLE IF EXISTS TBL_StationFlow;
DROP SEQUENCE IF EXISTS TBL_StationFlow_id;

-- 25. TBL_FlowForm
DROP TABLE IF EXISTS TBL_FlowForm;
DROP SEQUENCE IF EXISTS TBL_FlowForm_id;

-- 24. TBL_WorkFlow
DROP TABLE IF EXISTS TBL_WorkFlow;
DROP SEQUENCE IF EXISTS TBL_TBL_WorkFlow_id;

-- 23. TBL_WorkFlowStatus
DROP TABLE IF EXISTS TBL_WorkFlowStatus;
DROP SEQUENCE IF EXISTS TBL_WorkFlowStatus_id;

-- 22. TBL_Form
DROP TABLE IF EXISTS TBL_Form;
DROP SEQUENCE IF EXISTS TBL_Form_id;

-- 21. TBL_FormType
DROP TABLE IF EXISTS TBL_FormType;
DROP SEQUENCE IF EXISTS TBL_FormType_id;

-- 20. TBL_FormRole
DROP TABLE IF EXISTS TBL_FormRole;
DROP SEQUENCE IF EXISTS TBL_FormRole_id;

-- 19. TBL_SfisMO
DROP TABLE IF EXISTS TBL_SfisMO;
DROP SEQUENCE IF EXISTS TBL_SfisMO_id;

-- 18. TBL_ChipBindingUpdateSfis
DROP TABLE IF EXISTS TBL_ChipBindingUpdateSfis;
DROP SEQUENCE IF EXISTS TBL_ChipBindingUpdateSfis_id;

-- 17. TBL_ChipBindingUpdateSN
DROP TABLE IF EXISTS TBL_ChipBindingUpdateSN;
DROP SEQUENCE IF EXISTS TBL_ChipBindingUpdateSN_id;

-- 16. TBL_ChipBinding
DROP TABLE IF EXISTS TBL_ChipBinding;
DROP SEQUENCE IF EXISTS TBL_ChipBinding_id;

-- 15. TBL_ChipSN
DROP TABLE IF EXISTS TBL_ChipSN;
DROP SEQUENCE IF EXISTS TBL_ChipSN_id;

-- 14. TBL_Chip
DROP TABLE IF EXISTS TBL_Chip;
DROP SEQUENCE IF EXISTS TBL_Chip_id;

-- 13. TBL_ChipType
DROP TABLE IF EXISTS TBL_ChipType;
DROP SEQUENCE IF EXISTS TBL_ChipType_id;

-- 12. TBL_Vendor
DROP TABLE IF EXISTS TBL_Vendor;
DROP SEQUENCE IF EXISTS TBL_Vendor_id;

-- 11. TBL_SFIS
DROP TABLE IF EXISTS TBL_SFIS;
DROP SEQUENCE IF EXISTS TBL_SFIS_id;

-- 10. TBL_MO
DROP TABLE IF EXISTS TBL_MO;
DROP SEQUENCE IF EXISTS TBL_MO_id;

-- 9. TBL_Login
DROP TABLE IF EXISTS TBL_Login;
DROP SEQUENCE IF EXISTS TBL_Login_id;

-- 8.TBL_PC
DROP TABLE IF EXISTS TBL_PC;
DROP SEQUENCE IF EXISTS TBL_PC_id;

-- 7. TBL_Station
DROP TABLE IF EXISTS TBL_Station;
DROP SEQUENCE IF EXISTS TBL_Station_id;

-- 6. TBL_StationType
DROP TABLE IF EXISTS TBL_StationType;
DROP SEQUENCE IF EXISTS TBL_StationType_id;

-- 5. TBL_UserRoles
DROP TABLE IF EXISTS TBL_UserRoles;
DROP SEQUENCE IF EXISTS TBL_UserRoles_id;

-- 4. TBL_User
DROP TABLE IF EXISTS TBL_User;
DROP SEQUENCE IF EXISTS TBL_User_id;

-- 3. TBL_AccountRole
DROP TABLE IF EXISTS TBL_AccountRole;
DROP SEQUENCE IF EXISTS TBL_AccountRole_id;

-- 2. TBL_AccountStatus
DROP TABLE IF EXISTS TBL_AccountStatus;
DROP SEQUENCE IF EXISTS TBL_AccountStatus_id;

-- 1. TBL_RecordMark
DROP TABLE IF EXISTS TBL_RecordMark;
DROP SEQUENCE IF EXISTS TBL_RecordMark_id;

/*
=========================================================
Create Tables
=========================================================
*/
-- 1. TBL_RecordMark
CREATE SEQUENCE TBL_RecordMark_id as bigint;
CREATE TABLE TBL_RecordMark
(
    id bigint NOT NULL DEFAULT nextval('TBL_RecordMark_id'),
    name varchar(64) NOT NULL,
    description varchar(100)
);
ALTER TABLE TBL_RecordMark ADD CONSTRAINT PK_TBL_RecordMark_id PRIMARY KEY(id);
ALTER TABLE TBL_RecordMark ADD CONSTRAINT INDEX_TBL_RecordMark_name UNIQUE(name);

INSERT INTO TBL_RecordMark (name) VALUES('Available');
INSERT INTO TBL_RecordMark (name) VALUES('Inavailable');
INSERT INTO TBL_RecordMark (name) VALUES('Deleted');
INSERT INTO TBL_RecordMark (name) VALUES('Hidden');

-- 2. TBL_AccountStatus
CREATE SEQUENCE TBL_AccountStatus_id as bigint;
CREATE TABLE TBL_AccountStatus
(
    id bigint NOT NULL DEFAULT nextval('TBL_AccountStatus_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_AccountStatus ADD CONSTRAINT PK_TBL_AccountStatus_id PRIMARY KEY(id);
ALTER TABLE TBL_AccountStatus ADD CONSTRAINT INDEX_TBL_AccountStatus_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_AccountStatus (name) VALUES('Active');
INSERT INTO TBL_AccountStatus (name) VALUES('Inavtive');
INSERT INTO TBL_AccountStatus (name) VALUES('Deleted');
INSERT INTO TBL_AccountStatus (name) VALUES('Blocked');
INSERT INTO TBL_AccountStatus (name) VALUES('Expired');

-- 3. TBL_AccountRole
CREATE SEQUENCE TBL_AccountRole_id as bigint;
CREATE TABLE TBL_AccountRole
(
    id bigint NOT NULL DEFAULT nextval('TBL_AccountRole_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_AccountRole ADD CONSTRAINT PK_TBL_AccountRole_id PRIMARY KEY(id);
ALTER TABLE TBL_AccountRole ADD CONSTRAINT INDEX_TBL_AccountRole_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_AccountRole VALUES(DEFAULT, 'Administrator', 'ASRock SFIS System Manager', DEFAULT);
INSERT INTO TBL_AccountRole VALUES(DEFAULT, 'Supervisor', 'Factory Manager/Foreman', DEFAULT);
INSERT INTO TBL_AccountRole VALUES(DEFAULT, 'Operator', 'Production Line Operator', DEFAULT);

-- 4. TBL_User
CREATE SEQUENCE TBL_User_id as bigint;
CREATE TABLE TBL_User
(
    id bigint NOT NULL DEFAULT nextval('TBL_User_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    password varchar(64) NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expire_at timestamp,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_User ADD CONSTRAINT PK_TBL_User_id PRIMARY KEY(id);
ALTER TABLE TBL_User ADD CONSTRAINT INDEX_TBL_User_name UNIQUE(name, recordmark_id);
ALTER TABLE TBL_User ADD CONSTRAINT FK_TBL_User_status_id FOREIGN KEY (status_id) REFERENCES TBL_AccountStatus(id);

INSERT INTO TBL_User (name, description, password, status_id) VALUES('Administrator', 'System Administrator', 'admin#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('Supervisor', 'Production Line Manager', 'sfis#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('Operator', 'Production Line Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('SMT', 'SMT Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('DIP', 'SMT Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('WATS', 'SMT Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('TEST', 'SMT Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('PACK', 'SMT Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('QA', 'SMT Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));
INSERT INTO TBL_User (name, description, password, status_id) VALUES('REPAIR', 'REPAIR Operator', '#3515', (SELECT id FROM TBL_AccountStatus WHERE name='Active'));

-- 5. TBL_UserRoles
CREATE SEQUENCE TBL_UserRoles_id as bigint;
CREATE TABLE TBL_UserRoles
(
    id bigint NOT NULL DEFAULT nextval('TBL_UserRoles_id'),
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);
ALTER TABLE TBL_UserRoles ADD CONSTRAINT PK_TBL_UserRoles_id PRIMARY KEY(id);
ALTER TABLE TBL_UserRoles ADD CONSTRAINT FK_TBL_UserRoles_user_id FOREIGN KEY (user_id) REFERENCES TBL_User(id);
ALTER TABLE TBL_UserRoles ADD CONSTRAINT FK_TBL_UserRoles_role_id FOREIGN KEY (role_id) REFERENCES TBL_AccountRole(id);

INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='Administrator'), (SELECT id FROM TBL_AccountRole WHERE name='Administrator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='Supervisor'), (SELECT id FROM TBL_AccountRole WHERE name='Supervisor'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='Operator'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='SMT'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='DIP'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='WATS'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='TEST'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='PACK'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='QA'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));
INSERT INTO TBL_UserRoles VALUES(DEFAULT, (SELECT id FROM TBL_User WHERE name='REPAIR'), (SELECT id FROM TBL_AccountRole WHERE name='Operator'));

-- 6. TBL_StationType
CREATE SEQUENCE TBL_StationType_id as bigint;
CREATE TABLE TBL_StationType
(
    id bigint NOT NULL DEFAULT nextval('TBL_StationType_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_StationType ADD CONSTRAINT PK_TBL_StationType_id PRIMARY KEY(id);
ALTER TABLE TBL_StationType ADD CONSTRAINT INDEX_TBL_StationType_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_StationType VALUES(DEFAULT, 'Server', 'ASRock SFIS Server', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'Station', 'ALL Stations - Unspecified', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'SMT', 'Station - SMT', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'DIP', 'Station - DIP', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'WATS', 'Station - WATS', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'TEST', 'Station - TEST', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'PACK', 'Station - PACKING', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'QA', 'Station - QA', DEFAULT);
INSERT INTO TBL_StationType VALUES(DEFAULT, 'REPAIR', 'Station - REPAIR', DEFAULT);

-- 7. TBL_Station
CREATE SEQUENCE TBL_Station_id as bigint;
CREATE TABLE TBL_Station
(
    id bigint NOT NULL DEFAULT nextval('TBL_Station_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    type_id bigint NOT NULL,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_Station ADD CONSTRAINT PK_TBL_Station_id PRIMARY KEY(id);
ALTER TABLE TBL_Station ADD CONSTRAINT FK_TBL_TBL_Station_type_id FOREIGN KEY (type_id) REFERENCES TBL_StationType(id);
ALTER TABLE TBL_Station ADD CONSTRAINT INDEX_TBL_Station_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_Station VALUES(DEFAULT, 'Server', 'ASRock SFIS Server', (SELECT id FROM TBL_StationType WHERE name='Server'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'Station', 'ALL Stations - Unspecified', (SELECT id FROM TBL_StationType WHERE name='Station'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'SMT1', 'Station - SMT', (SELECT id FROM TBL_StationType WHERE name='SMT'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'SMT2', 'Station - SMT', (SELECT id FROM TBL_StationType WHERE name='SMT'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'DIP1', 'Station - DIP', (SELECT id FROM TBL_StationType WHERE name='DIP'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'DIP2', 'Station - DIP', (SELECT id FROM TBL_StationType WHERE name='DIP'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'WATS1', 'Station - WATS', (SELECT id FROM TBL_StationType WHERE name='WATS'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'TEST1', 'Station - TEST', (SELECT id FROM TBL_StationType WHERE name='TEST'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'PACK1', 'Station - PACKING', (SELECT id FROM TBL_StationType WHERE name='PACK'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'QA1', 'Station - QA', (SELECT id FROM TBL_StationType WHERE name='QA'), DEFAULT);
INSERT INTO TBL_Station VALUES(DEFAULT, 'REPAIR', 'Station - REPAIR', (SELECT id FROM TBL_StationType WHERE name='REPAIR'), DEFAULT);

-- 8.TBL_PC
CREATE SEQUENCE TBL_PC_id as bigint;
CREATE TABLE TBL_PC
(
    id bigint NOT NULL DEFAULT nextval('TBL_PC_id'),
    ipv4_addr varchar(15) NOT NULL,
    mac_addr varchar(12) NOT NULL,
    station_id bigint NOT NULL,
    description varchar(100),
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_PC ADD CONSTRAINT PK_TBL_PC_id PRIMARY KEY(id);
ALTER TABLE TBL_PC ADD CONSTRAINT FK_TBL_PC_station_id FOREIGN KEY (station_id) REFERENCES TBL_Station(id);
--ALTER TABLE TBL_PC ADD CONSTRAINT INDEX_TBL_PC_station_id UNIQUE(station_id);
ALTER TABLE TBL_PC ADD CONSTRAINT INDEX_TBL_PC_ip_mac UNIQUE(ipv4_addr, mac_addr, recordmark_id);

INSERT INTO TBL_PC VALUES(DEFAULT, 'SYSTEM', 'SYSTEM', (SELECT id FROM TBL_Station WHERE name='Server'), 'SystemManagenemt', DEFAULT, 1);

-- 9. TBL_Login
CREATE SEQUENCE TBL_Login_id as bigint;
CREATE TABLE TBL_Login
(
    id bigint NOT NULL DEFAULT nextval('TBL_Login_id'),
    user_id bigint NOT NULL,
    pc_id bigint NOT NULL,
    station_id bigint NOT NULL,
    token varchar(100) NOT NULL,
    login_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    logout_at timestamp
);
ALTER TABLE TBL_Login ADD CONSTRAINT PK_TBL_Login_id PRIMARY KEY(id);
ALTER TABLE TBL_Login ADD CONSTRAINT FK_TBL_Login_user_id FOREIGN KEY (user_id) REFERENCES TBL_User(id);
ALTER TABLE TBL_Login ADD CONSTRAINT FK_TBL_Login_pc_id FOREIGN KEY (pc_id) REFERENCES TBL_PC(id);
ALTER TABLE TBL_Login ADD CONSTRAINT FK_TBL_Login_station_id FOREIGN KEY (station_id) REFERENCES TBL_Station(id);

INSERT INTO TBL_Login VALUES(DEFAULT,
                             (SELECT id FROM TBL_User WHERE name='Administrator'),
                             (SELECT id FROM TBL_PC WHERE ipv4_addr='SYSTEM'),
                             (SELECT id FROM TBL_StationType WHERE name='Server'),
                             'SystemManagenemt00000000000000',
                             DEFAULT,
                             NULL
                            );

-- 10. TBL_MO
CREATE SEQUENCE TBL_MO_id as bigint;
CREATE TABLE TBL_MO
(
    id bigint NOT NULL DEFAULT nextval('TBL_MO_id'),
    code varchar(64) NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_MO ADD CONSTRAINT PK_TBL_MO_id PRIMARY KEY(id);
ALTER TABLE TBL_MO ADD CONSTRAINT INDEX_TBL_MO_code UNIQUE(code, recordmark_id);
ALTER TABLE TBL_MO ADD CONSTRAINT FK_TBL_MO_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);

-- 11. TBL_SFIS
CREATE SEQUENCE TBL_SFIS_id as bigint;
CREATE TABLE TBL_SFIS
(
    id bigint NOT NULL DEFAULT nextval('TBL_SFIS_id'),
    code varchar(64) NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_SFIS ADD CONSTRAINT PK_TBL_SFIS_id PRIMARY KEY(id);
ALTER TABLE TBL_SFIS ADD CONSTRAINT INDEX_TBL_SFIS_code UNIQUE(code, recordmark_id);
ALTER TABLE TBL_SFIS ADD CONSTRAINT FK_TBL_SFIS_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);

-- 12. TBL_Vendor
CREATE SEQUENCE TBL_Vendor_id as bigint;
CREATE TABLE TBL_Vendor
(
    id bigint NOT NULL DEFAULT nextval('TBL_Vendor_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_Vendor ADD CONSTRAINT PK_TBL_Vendor_id PRIMARY KEY(id);
ALTER TABLE TBL_Vendor ADD CONSTRAINT INDEX_TBL_Vendor_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_Vendor(name) VALUES('Intel');
INSERT INTO TBL_Vendor(name) VALUES('AMD');

-- 13. TBL_ChipType
CREATE SEQUENCE TBL_ChipType_id as bigint;
CREATE TABLE TBL_ChipType
(
    id bigint NOT NULL DEFAULT nextval('TBL_ChipType_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_ChipType ADD CONSTRAINT PK_TBL_ChipType_id PRIMARY KEY(id);
ALTER TABLE TBL_ChipType ADD CONSTRAINT INDEX_TBL_ChipType_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_ChipType(name) VALUES('Chipset');
INSERT INTO TBL_ChipType(name) VALUES('CPU');
INSERT INTO TBL_ChipType(name) VALUES('GPU');

-- 14. TBL_Chip
CREATE SEQUENCE TBL_Chip_id as bigint;
CREATE TABLE TBL_Chip
(
    id bigint NOT NULL DEFAULT nextval('TBL_Chip_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    vendor_id bigint NOT NULL,
    type_id bigint NOT NULL,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_Chip ADD CONSTRAINT PK_TBL_Chip_id PRIMARY KEY(id);
ALTER TABLE TBL_Chip ADD CONSTRAINT FK_TBL_Chip_login_id FOREIGN KEY (vendor_id) REFERENCES TBL_Vendor(id);
ALTER TABLE TBL_Chip ADD CONSTRAINT FK_TBL_Chip_type_id FOREIGN KEY (type_id) REFERENCES TBL_ChipType(id);
ALTER TABLE TBL_Chip ADD CONSTRAINT INDEX_TBL_Chip_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_Chip(name, vendor_id, type_id) VALUES('Intel Chipset', (SELECT id FROM TBL_Vendor WHERE name='Intel'), (SELECT id FROM TBL_ChipType WHERE name='Chipset'));
INSERT INTO TBL_Chip(name, vendor_id, type_id) VALUES('Intel CPU', (SELECT id FROM TBL_Vendor WHERE name='Intel'), (SELECT id FROM TBL_ChipType WHERE name='CPU'));
INSERT INTO TBL_Chip(name, vendor_id, type_id) VALUES('Intel GPU', (SELECT id FROM TBL_Vendor WHERE name='Intel'), (SELECT id FROM TBL_ChipType WHERE name='GPU'));
INSERT INTO TBL_Chip(name, vendor_id, type_id) VALUES('AMD Chipset', (SELECT id FROM TBL_Vendor WHERE name='AMD'), (SELECT id FROM TBL_ChipType WHERE name='Chipset'));
INSERT INTO TBL_Chip(name, vendor_id, type_id) VALUES('AMD CPU', (SELECT id FROM TBL_Vendor WHERE name='AMD'), (SELECT id FROM TBL_ChipType WHERE name='CPU'));
INSERT INTO TBL_Chip(name, vendor_id, type_id) VALUES('AMD GPU', (SELECT id FROM TBL_Vendor WHERE name='AMD'), (SELECT id FROM TBL_ChipType WHERE name='GPU'));

-- 15. TBL_ChipSN
CREATE SEQUENCE TBL_ChipSN_id as bigint;
CREATE TABLE TBL_ChipSN
(
    id bigint NOT NULL DEFAULT nextval('TBL_ChipSN_id'),
    code varchar(64) NOT NULL,
    chip_id bigint NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_ChipSN ADD CONSTRAINT PK_TBL_ChipSN_id PRIMARY KEY(id);
ALTER TABLE TBL_ChipSN ADD CONSTRAINT FK_TBL_ChipSN_chip_id FOREIGN KEY (chip_id) REFERENCES TBL_Chip(id);
ALTER TABLE TBL_ChipSN ADD CONSTRAINT FK_TBL_ChipSN_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);
ALTER TABLE TBL_ChipSN ADD CONSTRAINT INDEX_TBL_ChipSN_code UNIQUE(code, recordmark_id);

-- 16. TBL_ChipBinding
CREATE SEQUENCE TBL_ChipBinding_id as bigint;
CREATE TABLE TBL_ChipBinding
(
    id bigint NOT NULL DEFAULT nextval('TBL_ChipBinding_id'),
    sfis_id bigint NOT NULL,
    mo_id  bigint NOT NULL,
    chipSN_id  bigint NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0,
    conflictsfis_id bigint NOT NULL DEFAULT 0,
    conflictSN_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_ChipBinding ADD CONSTRAINT PK_TBL_ChipBinding_id PRIMARY KEY(id);
ALTER TABLE TBL_ChipBinding ADD CONSTRAINT FK_TBL_ChipBinding_sfis_id FOREIGN KEY (sfis_id) REFERENCES TBL_SFIS(id);
ALTER TABLE TBL_ChipBinding ADD CONSTRAINT FK_TBL_ChipBinding_mo_id FOREIGN KEY (mo_id) REFERENCES TBL_MO(id);
ALTER TABLE TBL_ChipBinding ADD CONSTRAINT FK_TBL_ChipBinding_chipSN_id FOREIGN KEY (chipSN_id) REFERENCES TBL_ChipSN(id);
ALTER TABLE TBL_ChipBinding ADD CONSTRAINT FK_TBL_ChipBinding_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);
ALTER TABLE TBL_ChipBinding ADD CONSTRAINT INDEX_TBL_ChipBinding_code UNIQUE(sfis_id, mo_id, chipSN_id, recordmark_id, conflictsfis_id, conflictSN_id);

-- 17. TBL_ChipBindingUpdateSN
CREATE SEQUENCE TBL_ChipBindingUpdateSN_id as bigint;
CREATE TABLE TBL_ChipBindingUpdateSN
(
    id bigint NOT NULL DEFAULT nextval('TBL_ChipBindingUpdateSN_id'),
    chipSN_id  bigint NOT NULL,
    chipBinding_id bigint NOT NULL,
    login_id bigint NOT NULL,
    update_at timestamp NOT NULL,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_ChipBindingUpdateSN ADD CONSTRAINT PK_TBL_ChipBindingUpdateSN_id PRIMARY KEY(id);
ALTER TABLE TBL_ChipBindingUpdateSN ADD CONSTRAINT FK_TBL_ChipSN_chipSN_id FOREIGN KEY (chipSN_id) REFERENCES TBL_ChipSN(id);
ALTER TABLE TBL_ChipBindingUpdateSN ADD CONSTRAINT INDEX_TBL_ChipBindingUpdateSN_code UNIQUE(chipSN_id, recordmark_id);

-- 18. TBL_ChipBindingUpdateSfis
CREATE SEQUENCE TBL_ChipBindingUpdateSfis_id as bigint;
CREATE TABLE TBL_ChipBindingUpdateSfis
(
    id bigint NOT NULL DEFAULT nextval('TBL_ChipBindingUpdateSfis_id'),
    sfis_id  bigint NOT NULL,
    chipBinding_id bigint NOT NULL,
    login_id bigint NOT NULL,
    update_at timestamp NOT NULL,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_ChipBindingUpdateSfis ADD CONSTRAINT PK_TBL_ChipBindingUpdateSfis_id PRIMARY KEY(id);
ALTER TABLE TBL_ChipBindingUpdateSfis ADD CONSTRAINT FK_TBL_ChipBindingUpdateSfis_sfis_id FOREIGN KEY (sfis_id) REFERENCES TBL_SFIS(id);
ALTER TABLE TBL_ChipBindingUpdateSfis ADD CONSTRAINT INDEX_TBL_ChipBindingUpdateSfis_code UNIQUE(sfis_id, recordmark_id);

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 19. TBL_SfisMO
CREATE SEQUENCE TBL_SfisMO_id as bigint;
CREATE TABLE TBL_SfisMO
(
    id bigint NOT NULL DEFAULT nextval('TBL_SfisMO_id'),
    sfis_id bigint NOT NULL,
    mo_id bigint NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_SfisMO ADD CONSTRAINT PK_TBL_SfisMO_id PRIMARY KEY(id);
ALTER TABLE TBL_SfisMO ADD CONSTRAINT FK_TBL_SfisMO_sfis_id FOREIGN KEY (sfis_id) REFERENCES TBL_SFIS(id);
ALTER TABLE TBL_SfisMO ADD CONSTRAINT FK_TBL_SfisMO_mo_id FOREIGN KEY (mo_id) REFERENCES TBL_MO(id);
ALTER TABLE TBL_SfisMO ADD CONSTRAINT FK_TBL_SfisMO_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);

-- 20. TBL_FormRole
CREATE SEQUENCE TBL_FormRole_id as bigint;
CREATE TABLE TBL_FormRole
(
    id bigint NOT NULL DEFAULT nextval('TBL_FormRole_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_FormRole ADD CONSTRAINT PK_TBL_FormRole_id PRIMARY KEY(id);

INSERT INTO TBL_FormRole VALUES(DEFAULT, 'Server', 'Server Only', DEFAULT);
INSERT INTO TBL_FormRole VALUES(DEFAULT, 'Station', 'Station Only', DEFAULT);
INSERT INTO TBL_FormRole VALUES(DEFAULT, 'Both ', 'Server and Station', DEFAULT);

-- 21. TBL_FormType
CREATE SEQUENCE TBL_FormType_id as bigint;
CREATE TABLE TBL_FormType
(
    id bigint NOT NULL DEFAULT nextval('TBL_FormType_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_FormType ADD CONSTRAINT PK_TBL_FormType_id PRIMARY KEY(id);

INSERT INTO TBL_FormType VALUES(DEFAULT, 'Form', '', DEFAULT);
INSERT INTO TBL_FormType VALUES(DEFAULT, 'Report', '', DEFAULT);
INSERT INTO TBL_FormType VALUES(DEFAULT, 'Dialog ', '', DEFAULT);

-- 22. TBL_Form
CREATE SEQUENCE TBL_Form_id as bigint;
CREATE TABLE TBL_Form
(
    id bigint NOT NULL DEFAULT nextval('TBL_Form_id'),
    name varchar(64) NOT NULL,
    caption varchar(100) NOT NULL,
    description varchar(100),
    formrole_id bigint NOT NULL,
    formtype_id bigint NOT NULL,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_Form ADD CONSTRAINT PK_TBL_Form_id PRIMARY KEY(id);
ALTER TABLE TBL_Form ADD CONSTRAINT FK_TBL_Form_formrole_id FOREIGN KEY (formrole_id) REFERENCES TBL_FormRole(id);
ALTER TABLE TBL_Form ADD CONSTRAINT FK_TBL_Form_formtype_id FOREIGN KEY (formtype_id) REFERENCES TBL_FormType(id);

INSERT INTO TBL_Form VALUES(DEFAULT, 'FORM001', 'Binding - Intel Chipset S/N', 'Binding - Intel Chipset S/N', (SELECT id FROM TBL_FormRole WHERE name='Station'), (SELECT id FROM TBL_FormType WHERE name='Form'), DEFAULT);
INSERT INTO TBL_Form VALUES(DEFAULT, 'FORM002', 'Binding - Intel CPU S/N', 'Binding - Intel CPU S/N', (SELECT id FROM TBL_FormRole WHERE name='Station'), (SELECT id FROM TBL_FormType WHERE name='Form'), DEFAULT);
INSERT INTO TBL_Form VALUES(DEFAULT, 'FORM003', 'Binding - Intel GPU S/N', 'Binding - Intel GPU S/N', (SELECT id FROM TBL_FormRole WHERE name='Station'), (SELECT id FROM TBL_FormType WHERE name='Form'), DEFAULT);
INSERT INTO TBL_Form VALUES(DEFAULT, 'FORM004', 'Binding - AMD Chipset S/N', 'Binding - AMD Chipset S/N', (SELECT id FROM TBL_FormRole WHERE name='Station'), (SELECT id FROM TBL_FormType WHERE name='Form'), DEFAULT);
INSERT INTO TBL_Form VALUES(DEFAULT, 'FORM005', 'Binding - AMD CPU S/N', 'Binding - AMD CPU S/N', (SELECT id FROM TBL_FormRole WHERE name='Station'), (SELECT id FROM TBL_FormType WHERE name='Form'), DEFAULT);
INSERT INTO TBL_Form VALUES(DEFAULT, 'FORM006', 'Binding - AMD GPU S/N', 'Binding - AMD GPU S/N', (SELECT id FROM TBL_FormRole WHERE name='Station'), (SELECT id FROM TBL_FormType WHERE name='Form'), DEFAULT);

-- 23. TBL_WorkFlowStatus
CREATE SEQUENCE TBL_WorkFlowStatus_id as bigint;
CREATE TABLE TBL_WorkFlowStatus
(
    id bigint NOT NULL DEFAULT nextval('TBL_WorkFlowStatus_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_WorkFlowStatus ADD CONSTRAINT PK_TBL_WorkFlowStatus_id PRIMARY KEY(id);

INSERT INTO TBL_WorkFlowStatus VALUES(DEFAULT, 'Disable', '', DEFAULT);
INSERT INTO TBL_WorkFlowStatus VALUES(DEFAULT, 'Start', '', DEFAULT);
INSERT INTO TBL_WorkFlowStatus VALUES(DEFAULT, 'Stop', '', DEFAULT);

-- 24. TBL_WorkFlow
CREATE SEQUENCE TBL_TBL_WorkFlow_id as bigint;
CREATE TABLE TBL_WorkFlow
(
    id bigint NOT NULL DEFAULT nextval('TBL_TBL_WorkFlow_id'),
    name varchar(64) NOT NULL,
    description varchar(100),
    status_id bigint NOT NULL,
    start_at timestamp DEFAULT NULL,
    expire_at timestamp DEFAULT NULL,
    start_at_enable integer NOT NULL DEFAULT 0,
    expire_at_enable integer NOT NULL DEFAULT 0,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_WorkFlow ADD CONSTRAINT PK_TBL_WorkFlow_id PRIMARY KEY(id);
ALTER TABLE TBL_WorkFlow ADD CONSTRAINT FK_TBL_WorkFlow_status_id FOREIGN KEY (status_id) REFERENCES TBL_WorkFlowStatus(id);
ALTER TABLE TBL_WorkFlow ADD CONSTRAINT INDEX_TBL_WorkFlow_name UNIQUE(name, recordmark_id);

INSERT INTO TBL_WorkFlow VALUES(DEFAULT, 'FLOW001', 'Binding - Intel Chipset S/N', (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start'), DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO TBL_WorkFlow VALUES(DEFAULT, 'FLOW002', 'Binding - AMD CPU S/N', (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start'), DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

-- 25. TBL_FlowForm
CREATE SEQUENCE TBL_FlowForm_id as bigint;
CREATE TABLE TBL_FlowForm
(
    id bigint NOT NULL DEFAULT nextval('TBL_FlowForm_id'),
    flow_id bigint NOT NULL,
    form_id bigint NOT NULL,
    order_number integer NOT NULL,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_FlowForm ADD CONSTRAINT PK_TBL_FlowForm_id PRIMARY KEY(id);
ALTER TABLE TBL_FlowForm ADD CONSTRAINT FK_TBL_FlowForm_flow_id FOREIGN KEY (flow_id) REFERENCES TBL_WorkFlow(id);
ALTER TABLE TBL_FlowForm ADD CONSTRAINT FK_TBL_FlowForm_form_id FOREIGN KEY (form_id) REFERENCES TBL_Form(id);

INSERT INTO TBL_FlowForm VALUES(DEFAULT, (SELECT id FROM TBL_WorkFlow WHERE name='FLOW001'), (SELECT id FROM TBL_Form WHERE name='FORM001'), 1, DEFAULT);
INSERT INTO TBL_FlowForm VALUES(DEFAULT, (SELECT id FROM TBL_WorkFlow WHERE name='FLOW002'), (SELECT id FROM TBL_Form WHERE name='FORM005'), 1, DEFAULT);
--INSERT INTO TBL_FlowForm VALUES(DEFAULT, (SELECT id FROM TBL_WorkFlow WHERE name='FLOW001'), (SELECT id FROM TBL_Form WHERE name='FORM005'), 1, DEFAULT);

-- 26. TBL_StationFlow
CREATE SEQUENCE TBL_StationFlow_id as bigint;
CREATE TABLE TBL_StationFlow
(
    id bigint NOT NULL DEFAULT nextval('TBL_StationFlow_id'),
    station_id bigint NOT NULL,
    flow_id bigint NOT NULL,
    status_id bigint NOT NULL,
    start_at timestamp DEFAULT NULL,
    expire_at timestamp DEFAULT NULL,
    start_at_enable integer NOT NULL DEFAULT 0,
    expire_at_enable integer NOT NULL DEFAULT 0,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_StationFlow ADD CONSTRAINT PK_TBL_StationFlow_id PRIMARY KEY(id);
ALTER TABLE TBL_StationFlow ADD CONSTRAINT FK_TBL_StationFlow_station_id FOREIGN KEY (station_id) REFERENCES TBL_Station(id);
ALTER TABLE TBL_StationFlow ADD CONSTRAINT FK_TBL_StationFlow_flow_id FOREIGN KEY (flow_id) REFERENCES TBL_WorkFlow(id);
ALTER TABLE TBL_StationFlow ADD CONSTRAINT FK_TBL_StationFlow_status_id FOREIGN KEY (status_id) REFERENCES TBL_WorkFlowStatus(id);

INSERT INTO TBL_StationFlow (station_id, flow_id, status_id) VALUES(
    (SELECT id FROM TBL_Station WHERE name='SMT1'),
    (SELECT id FROM TBL_WorkFlow WHERE name='FLOW001'),
    (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start')
);

INSERT INTO TBL_StationFlow (station_id, flow_id, status_id) VALUES(
    (SELECT id FROM TBL_Station WHERE name='SMT2'),
    (SELECT id FROM TBL_WorkFlow WHERE name='FLOW002'),
    (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start')
);

INSERT INTO TBL_StationFlow (station_id, flow_id, status_id) VALUES(
    (SELECT id FROM TBL_Station WHERE name='REPAIR'),
    (SELECT id FROM TBL_WorkFlow WHERE name='FLOW001'),
    (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start')
);

INSERT INTO TBL_StationFlow (station_id, flow_id, status_id) VALUES(
    (SELECT id FROM TBL_Station WHERE name='DIP1'),
    (SELECT id FROM TBL_WorkFlow WHERE name='FLOW001'),
    (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start')
);

INSERT INTO TBL_StationFlow (station_id, flow_id, status_id) VALUES(
    (SELECT id FROM TBL_Station WHERE name='DIP2'),
    (SELECT id FROM TBL_WorkFlow WHERE name='FLOW002'),
    (SELECT id FROM TBL_WorkFlowStatus WHERE name='Start')
);

-- 27. TBL_SystemEventType
CREATE SEQUENCE TBL_SystemEventType_id as bigint;
CREATE TABLE TBL_SystemEventType
(
    id bigint NOT NULL DEFAULT nextval('TBL_SystemEventType_id'),
    name varchar(64) NOT NULL,
    description varchar(256)
);
ALTER TABLE TBL_SystemEventType ADD CONSTRAINT PK_TBL_SystemEventType_id PRIMARY KEY(id);

INSERT INTO TBL_SystemEventType(name) VALUES('INFO');
INSERT INTO TBL_SystemEventType(name) VALUES('WARNING');
INSERT INTO TBL_SystemEventType(name) VALUES('ERROR');

-- 28. TBL_SystemEvent
CREATE SEQUENCE TBL_SystemEvent_id as bigint;
CREATE TABLE TBL_SystemEvent
(
    id bigint NOT NULL DEFAULT nextval('TBL_SystemEvent_id'),
    name varchar(64) NOT NULL,
    type_id bigint NOT NULL,
    description varchar(256)
);
ALTER TABLE TBL_SystemEvent ADD CONSTRAINT PK_TBL_SystemEvent_id PRIMARY KEY(id);

INSERT INTO TBL_SystemEvent(name, type_id) VALUES('I0000', (SELECT id FROM TBL_SystemEventType WHERE name='INFO'));
INSERT INTO TBL_SystemEvent(name, type_id) VALUES('W0000', (SELECT id FROM TBL_SystemEventType WHERE name='WARNING'));
INSERT INTO TBL_SystemEvent(name, type_id) VALUES('E0000', (SELECT id FROM TBL_SystemEventType WHERE name='ERROR'));

-- 29. TBL_SystemLog
CREATE TABLE TBL_SystemLog
(
    name varchar(64) NOT NULL,
    ipv4_addr varchar(15) NOT NULL,
    mac_addr varchar(12) NOT NULL,
    user_name varchar(64) NOT NULL,
    station_name varchar(64) NOT NULL,
    event_id integer NOT NULL,
    status_code varchar(64) NOT NULL,
    log_at timestamp DEFAULT CURRENT_TIMESTAMP,
    description varchar(512)
);
ALTER TABLE TBL_SystemLog ADD CONSTRAINT FK_TBL_SystemLog_event_id FOREIGN KEY (event_id) REFERENCES TBL_SystemEvent(id);


-- 30. TBL_DIPChipBinding
CREATE SEQUENCE TBL_DIPChipBinding_id as bigint;
CREATE TABLE TBL_DIPChipBinding
(
    id bigint NOT NULL DEFAULT nextval('TBL_DIPChipBinding_id'),
    chipbinding_id bigint NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_DIPChipBinding ADD CONSTRAINT PK_TBL_DIPChipBinding_id PRIMARY KEY(id);
ALTER TABLE TBL_DIPChipBinding ADD CONSTRAINT FK_TBL_DIPChipBinding_chipbinding_id FOREIGN KEY (chipbinding_id) REFERENCES TBL_ChipBinding(id);
ALTER TABLE TBL_DIPChipBinding ADD CONSTRAINT FK_TBL_DIPChipBinding_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);

-- 31. TBL_SfisStation
CREATE SEQUENCE TBL_SfisStation_id as bigint;
CREATE TABLE TBL_SfisStation
(
    id bigint NOT NULL DEFAULT nextval('TBL_SfisStation_id'),
    sfis_id  bigint NOT NULL,
    login_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recordmark_id bigint NOT NULL DEFAULT 0
);
ALTER TABLE TBL_SfisStation ADD CONSTRAINT PK_TBL_SfisStation_id PRIMARY KEY(id);
ALTER TABLE TBL_SfisStation ADD CONSTRAINT FK_TBL_SfisStation_sfis_id FOREIGN KEY (sfis_id) REFERENCES TBL_SFIS(id);
ALTER TABLE TBL_SfisStation ADD CONSTRAINT FK_TBL_SfisStation_login_id FOREIGN KEY (login_id) REFERENCES TBL_Login(id);

END TRANSACTION;
