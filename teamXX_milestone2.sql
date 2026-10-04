
-- DROP TAdBLES
BEGIN EXECUTE IMMEDIATE 'DROP TABLE work_assignment CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ticket_part CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE supplier_part CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE payment CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE invoice CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE repair_ticket CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE device CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE appointment CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE technician CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE supplier CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE part CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE service_type CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE business_client CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE customer CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE customer (
    customerid    NUMBER NOT NULL,
    firstname     VARCHAR2(50),
    lastname      VARCHAR2(50),
    email         VARCHAR2(100),
    phone         VARCHAR2(20),
    streetaddress VARCHAR2(100),
    state         CHAR(2),
    city          VARCHAR2(50),
    zipcode       VARCHAR2(10)
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customerid );

CREATE TABLE business_client (
    businessclientid NUMBER NOT NULL,
    businessname     VARCHAR2(100),
    contactperson    VARCHAR2(100),
    contactemail     VARCHAR2(100),
    contactphone     VARCHAR2(20),
    streetaddress    VARCHAR2(100),
    state            CHAR(2),
    city             VARCHAR2(50),
    zipcode          VARCHAR2(10)
);

ALTER TABLE business_client ADD CONSTRAINT business_client_pk PRIMARY KEY ( businessclientid );

CREATE TABLE service_type (
    servicetypeid     NUMBER NOT NULL,
    servicename       VARCHAR2(100),
    standardfee       NUMBER(8, 2),
    estimatedduration NUMBER(4),
    description       VARCHAR2(255)
);

ALTER TABLE service_type ADD CONSTRAINT service_type_pk PRIMARY KEY ( servicetypeid );

CREATE TABLE part (
    partid          NUMBER NOT NULL,
    partname        VARCHAR2(100),
    unitcost        NUMBER(8, 2),
    unitprice       NUMBER(8, 2),
    quantityinstock NUMBER,
    reorderlevel    NUMBER
);

ALTER TABLE part ADD CONSTRAINT part_pk PRIMARY KEY ( partid );

CREATE TABLE supplier (
    supplierid    NUMBER NOT NULL,
    contactname   VARCHAR2(100),
    suppliername  VARCHAR2(100),
    phone         VARCHAR2(20),
    email         VARCHAR2(100),
    streetaddress VARCHAR2(100)
);

ALTER TABLE supplier ADD CONSTRAINT supplier_pk PRIMARY KEY ( supplierid );

CREATE TABLE technician (
    technicianid NUMBER NOT NULL,
    firstname    VARCHAR2(50),
    lastname     VARCHAR2(50),
    phone        VARCHAR2(20),
    email        VARCHAR2(100),
    hiredate     DATE,
    hourlyrate   NUMBER(6, 2)
);

ALTER TABLE technician ADD CONSTRAINT technician_pk PRIMARY KEY ( technicianid );

CREATE TABLE appointment (
    appointmentid       NUMBER NOT NULL,
    appointmentdate     DATE,
    appointmenttime     DATE,
    reason              VARCHAR2(255),
    status              VARCHAR2(30),
    customer_customerid NUMBER NOT NULL
);

ALTER TABLE appointment ADD CONSTRAINT appointment_pk PRIMARY KEY ( appointmentid );

CREATE TABLE device (
    deviceid            NUMBER NOT NULL,
    devicetype          VARCHAR2(50),
    brand               VARCHAR2(50),
    model               VARCHAR2(50),
    serialnumber        VARCHAR2(100),
    purchasedate        DATE,
    customer_customerid NUMBER NOT NULL,
    businessclientid    NUMBER
);

ALTER TABLE device ADD CONSTRAINT device_pk PRIMARY KEY ( deviceid );

CREATE TABLE supplier_part (
    supplierprice       NUMBER(8, 2),
    leadtimedays        NUMBER,
    part_partid         NUMBER NOT NULL,
    supplier_supplierid NUMBER NOT NULL
);

ALTER TABLE supplier_part ADD CONSTRAINT supplier_part_pk PRIMARY KEY ( supplier_supplierid,
                                                                        part_partid );

CREATE TABLE repair_ticket (
    ticketid                   NUMBER NOT NULL,
    dateopened                 DATE,
    dateclosed                 DATE,
    problemdescription         VARCHAR2(55),
    repairstatus               VARCHAR2(30),
    estimatedcost              NUMBER(8, 2),
    actualcost                 NUMBER(8, 2),
    device_deviceid            NUMBER NOT NULL,
    service_type_servicetypeid NUMBER NOT NULL
);

ALTER TABLE repair_ticket ADD CONSTRAINT repair_ticket_pk PRIMARY KEY ( ticketid );

CREATE TABLE invoice (
    invoiceid              NUMBER NOT NULL,
    invoicedate            DATE,
    subtotal               NUMBER(8, 2),
    taxamount              NUMBER(8, 2),
    totalamount            NUMBER(8, 2),
    paymentstatus          VARCHAR2(30),
    repair_ticket_ticketid NUMBER NOT NULL
);

ALTER TABLE invoice ADD CONSTRAINT invoice_pk PRIMARY KEY ( invoiceid );

CREATE TABLE payment (
    paymentid         NUMBER NOT NULL,
    paymentamount     NUMBER(8, 2),
    paymentdate       DATE,
    paymentmethod     VARCHAR2(30),
    transactionnumber VARCHAR2(100),
    invoice_invoiceid NUMBER NOT NULL
);

ALTER TABLE payment ADD CONSTRAINT payment_pk PRIMARY KEY ( paymentid );

CREATE TABLE ticket_part (
    quantityused           NUMBER,
    linetotal              NUMBER(8, 2),
    repair_ticket_ticketid NUMBER NOT NULL,
    part_partid            NUMBER NOT NULL
);

ALTER TABLE ticket_part ADD CONSTRAINT ticket_part_pk PRIMARY KEY ( repair_ticket_ticketid,
                                                                    part_partid );

CREATE TABLE work_assignment (
    hoursworked             NUMBER(4, 1),
    workdate                DATE,
    notes                   VARCHAR2(255),
    repair_ticket_ticketid  NUMBER NOT NULL,
    technician_technicianid NUMBER NOT NULL
);

ALTER TABLE work_assignment ADD CONSTRAINT work_assignment_pk PRIMARY KEY ( technician_technicianid,
                                                                            repair_ticket_ticketid );

ALTER TABLE appointment
    ADD CONSTRAINT appointment_customer_fk FOREIGN KEY ( customer_customerid )
        REFERENCES customer ( customerid );

ALTER TABLE device
    ADD CONSTRAINT device_business_client_fk FOREIGN KEY ( businessclientid )
        REFERENCES business_client ( businessclientid );

ALTER TABLE device
    ADD CONSTRAINT device_customer_fk FOREIGN KEY ( customer_customerid )
        REFERENCES customer ( customerid );

ALTER TABLE supplier_part
    ADD CONSTRAINT supplier_part_part_fk FOREIGN KEY ( part_partid )
        REFERENCES part ( partid );

ALTER TABLE supplier_part
    ADD CONSTRAINT supplier_part_supplier_fk FOREIGN KEY ( supplier_supplierid )
        REFERENCES supplier ( supplierid );

ALTER TABLE repair_ticket
    ADD CONSTRAINT repair_ticket_device_fk FOREIGN KEY ( device_deviceid )
        REFERENCES device ( deviceid );

ALTER TABLE repair_ticket
    ADD CONSTRAINT repair_ticket_service_type_fk FOREIGN KEY ( service_type_servicetypeid )
        REFERENCES service_type ( servicetypeid );

ALTER TABLE invoice
    ADD CONSTRAINT invoice_repair_ticket_fk FOREIGN KEY ( repair_ticket_ticketid )
        REFERENCES repair_ticket ( ticketid );

ALTER TABLE payment
    ADD CONSTRAINT payment_invoice_fk FOREIGN KEY ( invoice_invoiceid )
        REFERENCES invoice ( invoiceid );

ALTER TABLE ticket_part
    ADD CONSTRAINT ticket_part_part_fk FOREIGN KEY ( part_partid )
        REFERENCES part ( partid );

ALTER TABLE ticket_part
    ADD CONSTRAINT ticket_part_repair_ticket_fk FOREIGN KEY ( repair_ticket_ticketid )
        REFERENCES repair_ticket ( ticketid );

ALTER TABLE work_assignment
    ADD CONSTRAINT wa_ticket_fk FOREIGN KEY ( repair_ticket_ticketid )
        REFERENCES repair_ticket ( ticketid );

ALTER TABLE work_assignment
    ADD CONSTRAINT work_assignment_technician_fk FOREIGN KEY ( technician_technicianid )
        REFERENCES technician ( technicianid );
        
        
        
        
-- INSERTS: CUSTOMER
INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1001, 'John', 'Smith', 'john@email.com', '5741112222', '123 Maple St', 'IN', 'South Bend', '46601');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1002, 'Maria', 'Lopez', 'maria@email.com', '5743334444', '456 Oak Ave', 'IN', 'Mishawaka', '46544');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1003, 'James', 'Carter', 'james.carter@email.com', '3175551003', '789 Pine Rd', 'IN', 'Indianapolis', '46201');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1004, 'Ava', 'Patel', 'ava.patel@email.com', '3175551004', '22 Willow Dr', 'IN', 'Carmel', '46032');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1005, 'Noah', 'Johnson', 'noah.j@email.com', '3175551005', '90 Cedar Ln', 'IN', 'Fishers', '46037');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1006, 'Emma', 'Davis', 'emma.d@email.com', '3175551006', '14 Birch Ct', 'IN', 'Bloomington', '47401');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1007, 'Liam', 'Walker', 'liam.walker@email.com', '3175551007', '305 Elm St', 'IN', 'Noblesville', '46060');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1008, 'Sophia', 'Nguyen', 'sophia.nguyen@email.com', '3175551008', '701 Ash Pl', 'IN', 'Greenwood', '46142');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1009, 'Elijah', 'Brown', 'elijah.brown@email.com', '3175551009', '88 Cherry St', 'IN', 'Plainfield', '46168');

INSERT INTO customer (customerid, firstname, lastname, email, phone, streetaddress, state, city, zipcode)
VALUES (1010, 'Mia', 'Wilson', 'mia.wilson@email.com', '3175551010', '17 River Rd', 'IN', 'Avon', '46123');

-- INSERTS: BUSINESS_CLIENT
INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5001, 'TechWorks LLC', 'Sarah Lee', 'sarah@techworks.com', '3175552001', '800 Market St', 'IN', 'Indianapolis', '46204');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5002, 'OfficeNet Inc', 'Daniel Kim', 'daniel@officenet.com', '3175552002', '900 Meridian St', 'IN', 'Indianapolis', '46205');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5003, 'Indy Health Group', 'Lisa Martin', 'lisa@indyhealth.com', '3175552003', '1000 Health Dr', 'IN', 'Indianapolis', '46202');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5004, 'Purdue Tech Lab', 'Kevin Moore', 'kevin@purdue-techlab.edu', '7655552004', '610 Campus Way', 'IN', 'West Lafayette', '47906');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5005, 'Hoosier Legal Services', 'Emily Clark', 'emily@hoosierlegal.com', '3175552005', '77 Court St', 'IN', 'Indianapolis', '46225');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5006, 'Midwest Retail Co', 'Ryan Hall', 'ryan@midwestretail.com', '3175552006', '515 Commerce Blvd', 'IN', 'Fishers', '46038');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5007, 'Summit Real Estate', 'Olivia Perez', 'olivia@summitrealestate.com', '3175552007', '42 Skyline Ave', 'IN', 'Carmel', '46032');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5008, 'Northside Dental', 'Nathan Reed', 'nathan@northsidedental.com', '3175552008', '222 Smile Ln', 'IN', 'Noblesville', '46060');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5009, 'Greenlight Media', 'Chloe Adams', 'chloe@greenlightmedia.com', '3175552009', '390 Studio Dr', 'IN', 'Greenwood', '46143');

INSERT INTO business_client (businessclientid, businessname, contactperson, contactemail, contactphone, streetaddress, state, city, zipcode)
VALUES (5010, 'Circle City Schools', 'Marcus Hill', 'marcus@circlecityschools.edu', '3175552010', '120 School Rd', 'IN', 'Indianapolis', '46227');

-- INSERTS: SERVICE_TYPE
INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (1, 'Screen Repair', 120.00, 90, 'Replacement of damaged display');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (2, 'Battery Replacement', 85.00, 45, 'Install new battery');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (3, 'Keyboard Repair', 70.00, 60, 'Fix keyboard issues');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (4, 'Water Damage Repair', 150.00, 120, 'Clean and repair water damage');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (5, 'Virus Removal', 60.00, 45, 'Remove malware and viruses');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (6, 'Software Install', 40.00, 30, 'Install operating system or software');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (7, 'Hard Drive Replacement', 100.00, 90, 'Replace HDD or SSD');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (8, 'Data Recovery', 200.00, 180, 'Recover lost or deleted data');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (9, 'Charging Port Repair', 80.00, 60, 'Fix charging and power issues');

INSERT INTO service_type (servicetypeid, servicename, standardfee, estimatedduration, description)
VALUES (10, 'Camera Repair', 95.00, 60, 'Repair camera hardware');

-- INSERTS: PART
INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6001, 'Laptop Screen 15in', 55.00, 95.00, 20, 5);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6002, 'Phone Battery A1', 18.00, 40.00, 50, 10);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6003, 'Laptop Keyboard', 22.00, 50.00, 25, 5);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6004, 'Charging Port Module', 12.00, 35.00, 40, 8);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6005, '1TB SSD', 60.00, 110.00, 15, 4);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6006, 'Tablet Screen 10in', 48.00, 85.00, 18, 5);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6007, 'Cooling Fan', 15.00, 32.00, 30, 6);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6008, 'Webcam Module', 14.00, 30.00, 22, 5);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6009, 'RAM 16GB Stick', 28.00, 55.00, 35, 7);

INSERT INTO part (partid, partname, unitcost, unitprice, quantityinstock, reorderlevel)
VALUES (6010, 'Motherboard Cable Set', 9.00, 22.00, 45, 10);

-- INSERTS: SUPPLIER
INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7001, 'Chris Brown', 'Midwest Parts Supply', '3175553001', 'sales@midwestparts.com', '1200 West St');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7002, 'Alicia Green', 'RepairSource', '3175553002', 'orders@repairsource.com', '1400 East St');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7003, 'Brian Scott', 'Tech Components Plus', '3175553003', 'brian@techcomponents.com', '15 Supply Rd');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7004, 'Rachel Evans', 'Device Depot', '3175553004', 'rachel@devicedepot.com', '88 Parts Ave');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7005, 'Tyler Young', 'Hoosier Hardware', '3175553005', 'tyler@hoosierhardware.com', '56 Warehouse Blvd');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7006, 'Jasmine Brooks', 'Prime Screens', '3175553006', 'jasmine@primescreens.com', '202 Glass Ln');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7007, 'Eric Turner', 'Battery Source Co', '3175553007', 'eric@batterysource.com', '44 Power Dr');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7008, 'Megan Bell', 'SSD Warehouse', '3175553008', 'megan@ssdwarehouse.com', '93 Storage Ct');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7009, 'Victor Allen', 'Laptop Essentials', '3175553009', 'victor@laptopessentials.com', '17 Board St');

INSERT INTO supplier (supplierid, contactname, suppliername, phone, email, streetaddress)
VALUES (7010, 'Hannah Price', 'Mobile Repair Hub', '3175553010', 'hannah@mobilerepairhub.com', '76 Phone Pkwy');

-- INSERTS: TECHNICIAN
INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4001, 'Alex', 'Brown', '3175554001', 'alex.brown@techfixpro.com', DATE '2024-01-15', 25.00);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4002, 'Chris', 'Davis', '3175554002', 'chris.davis@techfixpro.com', DATE '2024-03-10', 28.00);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4003, 'Nina', 'Lopez', '3175554003', 'nina.lopez@techfixpro.com', DATE '2024-05-22', 26.50);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4004, 'Ethan', 'Cole', '3175554004', 'ethan.cole@techfixpro.com', DATE '2024-06-18', 24.50);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4005, 'Grace', 'Hill', '3175554005', 'grace.hill@techfixpro.com', DATE '2024-08-01', 27.00);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4006, 'Owen', 'Reed', '3175554006', 'owen.reed@techfixpro.com', DATE '2024-09-12', 23.75);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4007, 'Chloe', 'Adams', '3175554007', 'chloe.adams@techfixpro.com', DATE '2024-11-07', 29.00);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4008, 'Landon', 'Turner', '3175554008', 'landon.turner@techfixpro.com', DATE '2025-01-20', 25.75);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4009, 'Zoe', 'Mitchell', '3175554009', 'zoe.mitchell@techfixpro.com', DATE '2025-02-14', 28.50);

INSERT INTO technician (technicianid, firstname, lastname, phone, email, hiredate, hourlyrate)
VALUES (4010, 'Caleb', 'Parker', '3175554010', 'caleb.parker@techfixpro.com', DATE '2025-03-03', 24.25);

-- INSERTS: APPOINTMENT
INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1101, DATE '2026-04-12', TO_DATE('2026-04-12 09:00', 'YYYY-MM-DD HH24:MI'), 'Phone screen cracked', 'Scheduled', 1001);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1102, DATE '2026-04-13', TO_DATE('2026-04-13 10:00', 'YYYY-MM-DD HH24:MI'), 'Laptop overheating', 'Scheduled', 1002);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1103, DATE '2026-04-13', TO_DATE('2026-04-13 11:30', 'YYYY-MM-DD HH24:MI'), 'Tablet not charging', 'Completed', 1003);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1104, DATE '2026-04-14', TO_DATE('2026-04-14 13:00', 'YYYY-MM-DD HH24:MI'), 'Battery drains fast', 'Scheduled', 1004);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1105, DATE '2026-04-14', TO_DATE('2026-04-14 14:00', 'YYYY-MM-DD HH24:MI'), 'Keyboard keys stuck', 'Completed', 1005);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1106, DATE '2026-04-15', TO_DATE('2026-04-15 09:30', 'YYYY-MM-DD HH24:MI'), 'Virus removal service', 'Scheduled', 1006);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1107, DATE '2026-04-15', TO_DATE('2026-04-15 11:00', 'YYYY-MM-DD HH24:MI'), 'SSD upgrade', 'Completed', 1007);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1108, DATE '2026-04-16', TO_DATE('2026-04-16 12:30', 'YYYY-MM-DD HH24:MI'), 'Camera blurry', 'Scheduled', 1008);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1109, DATE '2026-04-16', TO_DATE('2026-04-16 15:00', 'YYYY-MM-DD HH24:MI'), 'Water damage inspection', 'Scheduled', 1009);

INSERT INTO appointment (appointmentid, appointmentdate, appointmenttime, reason, status, customer_customerid)
VALUES (1110, DATE '2026-04-17', TO_DATE('2026-04-17 16:00', 'YYYY-MM-DD HH24:MI'), 'Charging port issue', 'Completed', 1010);

-- INSERTS: DEVICE
INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2001, 'Laptop', 'Dell', 'XPS 13', 'SN12345', DATE '2024-06-01', 1001, NULL);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2002, 'Phone', 'Apple', 'iPhone 13', 'SN88888', DATE '2023-08-15', 1002, NULL);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2003, 'Tablet', 'Samsung', 'Galaxy Tab S8', 'SN20003', DATE '2024-01-10', 1003, NULL);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2004, 'Laptop', 'HP', 'Pavilion 15', 'SN20004', DATE '2022-11-20', 1004, 5001);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2005, 'Desktop', 'Lenovo', 'ThinkCentre M70', 'SN20005', DATE '2021-05-17', 1005, 5002);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2006, 'Phone', 'Samsung', 'Galaxy S22', 'SN20006', DATE '2023-02-14', 1006, NULL);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2007, 'Laptop', 'Apple', 'MacBook Air', 'SN20007', DATE '2024-04-09', 1007, 5004);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2008, 'Tablet', 'Apple', 'iPad Air', 'SN20008', DATE '2023-09-03', 1008, 5007);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2009, 'Phone', 'Google', 'Pixel 8', 'SN20009', DATE '2024-10-01', 1009, NULL);

INSERT INTO device (deviceid, devicetype, brand, model, serialnumber, purchasedate, customer_customerid, businessclientid)
VALUES (2010, 'Laptop', 'Acer', 'Aspire 5', 'SN20010', DATE '2022-07-25', 1010, 5010);

-- INSERTS: SUPPLIER_PART
INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (52.00, 5, 6001, 7001);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (17.50, 3, 6002, 7007);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (20.00, 4, 6003, 7003);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (10.50, 2, 6004, 7010);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (58.00, 6, 6005, 7008);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (45.00, 5, 6006, 7006);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (13.00, 3, 6007, 7005);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (12.50, 4, 6008, 7004);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (26.00, 5, 6009, 7009);

INSERT INTO supplier_part (supplierprice, leadtimedays, part_partid, supplier_supplierid)
VALUES (8.00, 2, 6010, 7002);

-- INSERTS: REPAIR_TICKET
INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3001, DATE '2026-02-01', NULL, 'Screen not turning on', 'Open', 120.00, NULL, 2001, 1);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3002, DATE '2026-02-03', NULL, 'Battery drains fast', 'In Progress', 85.00, NULL, 2002, 2);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3003, DATE '2026-02-05', DATE '2026-02-07', 'Keyboard not responding', 'Closed', 70.00, 68.00, 2003, 3);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3004, DATE '2026-02-06', DATE '2026-02-09', 'Water damage after spill', 'Closed', 150.00, 165.00, 2004, 4);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3005, DATE '2026-02-08', NULL, 'Laptop infected with malware', 'Open', 60.00, NULL, 2005, 5);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3006, DATE '2026-02-10', DATE '2026-02-10', 'Operating system reinstall', 'Closed', 40.00, 40.00, 2006, 6);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3007, DATE '2026-02-12', NULL, 'SSD failure and replacement needed', 'In Progress', 100.00, NULL, 2007, 7);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3008, DATE '2026-02-14', NULL, 'Need deleted files recovered', 'Open', 200.00, NULL, 2008, 8);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3009, DATE '2026-02-16', DATE '2026-02-18', 'Phone only charges at angle', 'Closed', 80.00, 78.00, 2009, 9);

INSERT INTO repair_ticket (ticketid, dateopened, dateclosed, problemdescription, repairstatus, estimatedcost, actualcost, device_deviceid, service_type_servicetypeid)
VALUES (3010, DATE '2026-02-18', NULL, 'Front camera not working', 'In Progress', 95.00, NULL, 2010, 10);

-- INSERTS: INVOICE
INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8001, DATE '2026-02-02', 120.00, 8.40, 128.40, 'Unpaid', 3001);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8002, DATE '2026-02-04', 85.00, 5.95, 90.95, 'Paid', 3002);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8003, DATE '2026-02-07', 68.00, 4.76, 72.76, 'Paid', 3003);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8004, DATE '2026-02-09', 165.00, 11.55, 176.55, 'Paid', 3004);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8005, DATE '2026-02-09', 60.00, 4.20, 64.20, 'Unpaid', 3005);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8006, DATE '2026-02-10', 40.00, 2.80, 42.80, 'Paid', 3006);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8007, DATE '2026-02-13', 100.00, 7.00, 107.00, 'Partial', 3007);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8008, DATE '2026-02-15', 200.00, 14.00, 214.00, 'Unpaid', 3008);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8009, DATE '2026-02-18', 78.00, 5.46, 83.46, 'Paid', 3009);

INSERT INTO invoice (invoiceid, invoicedate, subtotal, taxamount, totalamount, paymentstatus, repair_ticket_ticketid)
VALUES (8010, DATE '2026-02-19', 95.00, 6.65, 101.65, 'Unpaid', 3010);

-- INSERTS: PAYMENT
INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9001, 128.40, DATE '2026-02-02', 'Credit Card', 'TXN1001', 8001);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9002, 90.95, DATE '2026-02-04', 'Cash', 'TXN1002', 8002);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9003, 72.76, DATE '2026-02-07', 'Debit Card', 'TXN1003', 8003);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9004, 176.55, DATE '2026-02-09', 'Credit Card', 'TXN1004', 8004);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9005, 20.00, DATE '2026-02-10', 'Cash', 'TXN1005', 8005);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9006, 42.80, DATE '2026-02-10', 'Debit Card', 'TXN1006', 8006);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9007, 50.00, DATE '2026-02-14', 'Credit Card', 'TXN1007', 8007);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9008, 75.00, DATE '2026-02-16', 'Cash', 'TXN1008', 8008);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9009, 83.46, DATE '2026-02-18', 'Debit Card', 'TXN1009', 8009);

INSERT INTO payment (paymentid, paymentamount, paymentdate, paymentmethod, transactionnumber, invoice_invoiceid)
VALUES (9010, 25.00, DATE '2026-02-20', 'Credit Card', 'TXN1010', 8010);

-- INSERTS: TICKET_PART
INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 95.00, 3001, 6001);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 40.00, 3002, 6002);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 50.00, 3003, 6003);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 35.00, 3004, 6004);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 22.00, 3005, 6010);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 0.00, 3006, 6010);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 110.00, 3007, 6005);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 30.00, 3008, 6008);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 35.00, 3009, 6004);

INSERT INTO ticket_part (quantityused, linetotal, repair_ticket_ticketid, part_partid)
VALUES (1, 30.00, 3010, 6008);

-- INSERTS: WORK_ASSIGNMENT
INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (1.5, DATE '2026-02-01', 'Initial inspection completed', 3001, 4001);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (2.0, DATE '2026-02-03', 'Battery diagnostic and replacement', 3002, 4002);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (1.8, DATE '2026-02-05', 'Keyboard replacement finished', 3003, 4003);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (2.5, DATE '2026-02-06', 'Water damage cleanup and testing', 3004, 4004);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (1.2, DATE '2026-02-08', 'Malware scan started', 3005, 4005);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (1.0, DATE '2026-02-10', 'Operating system reinstalled', 3006, 4006);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (2.3, DATE '2026-02-12', 'SSD replacement in progress', 3007, 4007);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (3.0, DATE '2026-02-14', 'Data recovery process running', 3008, 4008);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (1.4, DATE '2026-02-16', 'Charging port repaired', 3009, 4009);

INSERT INTO work_assignment (hoursworked, workdate, notes, repair_ticket_ticketid, technician_technicianid)
VALUES (1.7, DATE '2026-02-18', 'Camera module diagnosis', 3010, 4010);


DESCRIBE customer;
DESCRIBE business_client;
DESCRIBE service_type;
DESCRIBE part;
DESCRIBE supplier;
DESCRIBE technician;
DESCRIBE appointment;
DESCRIBE device;
DESCRIBE supplier_part;
DESCRIBE repair_ticket;
DESCRIBE invoice;
DESCRIBE payment;
DESCRIBE ticket_part;
DESCRIBE work_assignment;

SELECT * FROM customer;
SELECT * FROM business_client;
SELECT * FROM service_type;
SELECT * FROM part;
SELECT * FROM supplier;
SELECT * FROM technician;
SELECT * FROM appointment;
SELECT * FROM device;
SELECT * FROM supplier_part;
SELECT * FROM repair_ticket;
SELECT * FROM invoice;
SELECT * FROM payment;
SELECT * FROM ticket_part;
SELECT * FROM work_assignment;