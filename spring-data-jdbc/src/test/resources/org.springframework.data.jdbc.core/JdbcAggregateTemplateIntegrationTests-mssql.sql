DROP TABLE IF EXISTS MANUAL;
DROP TABLE IF EXISTS LEGO_SET;
CREATE TABLE LEGO_SET
(
  [id1]  BIGINT IDENTITY PRIMARY KEY,
  NAME VARCHAR(30)
);
CREATE TABLE MANUAL
(
  [id2]         BIGINT IDENTITY PRIMARY KEY,
  LEGO_SET    BIGINT,
  ALTERNATIVE BIGINT,
  CONTENT     VARCHAR(2000)
);
ALTER TABLE MANUAL
  ADD FOREIGN KEY (LEGO_SET) REFERENCES LEGO_SET (id1);

DROP TABLE IF EXISTS Child_No_Id;
DROP TABLE IF EXISTS ONE_TO_ONE_PARENT;
CREATE TABLE ONE_TO_ONE_PARENT
(
  [id3]     BIGINT IDENTITY PRIMARY KEY,
  content VARCHAR(30)
);
CREATE TABLE Child_No_Id
(
  ONE_TO_ONE_PARENT BIGINT PRIMARY KEY,
  [content]           VARCHAR(30)
);

DROP TABLE IF EXISTS element_no_id;
DROP TABLE IF EXISTS LIST_PARENT;
DROP TABLE IF EXISTS SIMPLE_LIST_PARENT;
CREATE TABLE LIST_PARENT
(
  [id4]  BIGINT IDENTITY PRIMARY KEY,
  NAME VARCHAR(100)
);
CREATE TABLE SIMPLE_LIST_PARENT
(
  ID  BIGINT IDENTITY PRIMARY KEY,
  NAME VARCHAR(100)
);
CREATE TABLE element_no_id
(
  CONTENT         VARCHAR(100),
  SIMPLE_LIST_PARENT_key BIGINT,
  SIMPLE_LIST_PARENT     BIGINT,
  LIST_PARENT_key BIGINT,
  LIST_PARENT     BIGINT
);

DROP TABLE IF EXISTS BYTE_ARRAY_OWNER;
CREATE TABLE BYTE_ARRAY_OWNER
(
  ID          BIGINT IDENTITY PRIMARY KEY,
  BINARY_DATA VARBINARY(20) NOT NULL
);

DROP TABLE IF EXISTS CHAIN0;
DROP TABLE IF EXISTS CHAIN1;
DROP TABLE IF EXISTS CHAIN2;
DROP TABLE IF EXISTS CHAIN3;
DROP TABLE IF EXISTS CHAIN4;

CREATE TABLE CHAIN4
(
  FOUR       BIGINT IDENTITY PRIMARY KEY,
  FOUR_VALUE VARCHAR(20)
);

CREATE TABLE CHAIN3
(
  THREE       BIGINT IDENTITY PRIMARY KEY,
  THREE_VALUE VARCHAR(20),
  CHAIN4      BIGINT,
  FOREIGN KEY (CHAIN4) REFERENCES CHAIN4 (FOUR)
);

CREATE TABLE CHAIN2
(
  TWO       BIGINT IDENTITY PRIMARY KEY,
  TWO_VALUE VARCHAR(20),
  CHAIN3    BIGINT,
  FOREIGN KEY (CHAIN3) REFERENCES CHAIN3 (THREE)
);

CREATE TABLE CHAIN1
(
  ONE       BIGINT IDENTITY PRIMARY KEY,
  ONE_VALUE VARCHAR(20),
  CHAIN2    BIGINT,
  FOREIGN KEY (CHAIN2) REFERENCES CHAIN2 (TWO)
);

CREATE TABLE CHAIN0
(
  ZERO       BIGINT IDENTITY PRIMARY KEY,
  ZERO_VALUE VARCHAR(20),
  CHAIN1     BIGINT,
  FOREIGN KEY (CHAIN1) REFERENCES CHAIN1 (ONE)
);

DROP TABLE IF EXISTS NO_ID_CHAIN0;
DROP TABLE IF EXISTS NO_ID_CHAIN1;
DROP TABLE IF EXISTS NO_ID_CHAIN2;
DROP TABLE IF EXISTS NO_ID_CHAIN3;
DROP TABLE IF EXISTS NO_ID_CHAIN4;

CREATE TABLE NO_ID_CHAIN4
(
  FOUR       BIGINT IDENTITY PRIMARY KEY,
  FOUR_VALUE VARCHAR(20)
);

CREATE TABLE NO_ID_CHAIN3
(
  THREE_VALUE VARCHAR(20),
  NO_ID_CHAIN4      BIGINT,
  FOREIGN KEY (NO_ID_CHAIN4) REFERENCES NO_ID_CHAIN4 (FOUR)
);

CREATE TABLE NO_ID_CHAIN2
(
  TWO_VALUE VARCHAR(20),
  NO_ID_CHAIN4    BIGINT,
  FOREIGN KEY (NO_ID_CHAIN4) REFERENCES NO_ID_CHAIN4 (FOUR)
);

CREATE TABLE NO_ID_CHAIN1
(
  ONE_VALUE VARCHAR(20),
  NO_ID_CHAIN4    BIGINT,
  FOREIGN KEY (NO_ID_CHAIN4) REFERENCES NO_ID_CHAIN4 (FOUR)
);

CREATE TABLE NO_ID_CHAIN0
(
  ZERO_VALUE VARCHAR(20),
  NO_ID_CHAIN4     BIGINT,
  FOREIGN KEY (NO_ID_CHAIN4) REFERENCES NO_ID_CHAIN4 (FOUR)
);

DROP TABLE IF EXISTS NO_ID_LIST_CHAIN0;
DROP TABLE IF EXISTS NO_ID_LIST_CHAIN1;
DROP TABLE IF EXISTS NO_ID_LIST_CHAIN2;
DROP TABLE IF EXISTS NO_ID_LIST_CHAIN3;
DROP TABLE IF EXISTS NO_ID_LIST_CHAIN4;

CREATE TABLE NO_ID_LIST_CHAIN4
(
  FOUR       BIGINT IDENTITY PRIMARY KEY,
  FOUR_VALUE VARCHAR(20)
);

CREATE TABLE NO_ID_LIST_CHAIN3
(
  THREE_VALUE           VARCHAR(20),
  NO_ID_LIST_CHAIN4     BIGINT,
  NO_ID_LIST_CHAIN4_KEY BIGINT,
  PRIMARY KEY (NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY),
  FOREIGN KEY (NO_ID_LIST_CHAIN4) REFERENCES NO_ID_LIST_CHAIN4 (FOUR)
);

CREATE TABLE NO_ID_LIST_CHAIN2
(
  TWO_VALUE             VARCHAR(20),
  NO_ID_LIST_CHAIN4     BIGINT,
  NO_ID_LIST_CHAIN4_KEY BIGINT,
  NO_ID_LIST_CHAIN3_KEY BIGINT,
  PRIMARY KEY (NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY,
               NO_ID_LIST_CHAIN3_KEY),
  FOREIGN KEY (
               NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY
    ) REFERENCES NO_ID_LIST_CHAIN3 (
                                    NO_ID_LIST_CHAIN4,
                                    NO_ID_LIST_CHAIN4_KEY
    )
);

CREATE TABLE NO_ID_LIST_CHAIN1
(
  ONE_VALUE             VARCHAR(20),
  NO_ID_LIST_CHAIN4     BIGINT,
  NO_ID_LIST_CHAIN4_KEY BIGINT,
  NO_ID_LIST_CHAIN3_KEY BIGINT,
  NO_ID_LIST_CHAIN2_KEY BIGINT,
  PRIMARY KEY (NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY,
               NO_ID_LIST_CHAIN3_KEY,
               NO_ID_LIST_CHAIN2_KEY),
  FOREIGN KEY (
               NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY,
               NO_ID_LIST_CHAIN3_KEY
    ) REFERENCES NO_ID_LIST_CHAIN2 (
                                    NO_ID_LIST_CHAIN4,
                                    NO_ID_LIST_CHAIN4_KEY,
                                    NO_ID_LIST_CHAIN3_KEY
    )
);

CREATE TABLE NO_ID_LIST_CHAIN0
(
  ZERO_VALUE            VARCHAR(20),
  NO_ID_LIST_CHAIN4     BIGINT,
  NO_ID_LIST_CHAIN4_KEY BIGINT,
  NO_ID_LIST_CHAIN3_KEY BIGINT,
  NO_ID_LIST_CHAIN2_KEY BIGINT,
  NO_ID_LIST_CHAIN1_KEY BIGINT,
  PRIMARY KEY (NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY,
               NO_ID_LIST_CHAIN3_KEY,
               NO_ID_LIST_CHAIN2_KEY,
               NO_ID_LIST_CHAIN1_KEY),
  FOREIGN KEY (
               NO_ID_LIST_CHAIN4,
               NO_ID_LIST_CHAIN4_KEY,
               NO_ID_LIST_CHAIN3_KEY,
               NO_ID_LIST_CHAIN2_KEY
    ) REFERENCES NO_ID_LIST_CHAIN1 (
                                    NO_ID_LIST_CHAIN4,
                                    NO_ID_LIST_CHAIN4_KEY,
                                    NO_ID_LIST_CHAIN3_KEY,
                                    NO_ID_LIST_CHAIN2_KEY
    )
);

DROP TABLE IF EXISTS NO_ID_MAP_CHAIN0;
DROP TABLE IF EXISTS NO_ID_MAP_CHAIN1;
DROP TABLE IF EXISTS NO_ID_MAP_CHAIN2;
DROP TABLE IF EXISTS NO_ID_MAP_CHAIN3;
DROP TABLE IF EXISTS NO_ID_MAP_CHAIN4;

CREATE TABLE NO_ID_MAP_CHAIN4
(
  FOUR       BIGINT IDENTITY PRIMARY KEY,
  FOUR_VALUE VARCHAR(20)
);

CREATE TABLE NO_ID_MAP_CHAIN3
(
  THREE_VALUE           VARCHAR(20),
  NO_ID_MAP_CHAIN4     BIGINT,
  NO_ID_MAP_CHAIN4_KEY VARCHAR(20),
  PRIMARY KEY (NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY),
  FOREIGN KEY (NO_ID_MAP_CHAIN4) REFERENCES NO_ID_MAP_CHAIN4 (FOUR)
);

CREATE TABLE NO_ID_MAP_CHAIN2
(
  TWO_VALUE             VARCHAR(20),
  NO_ID_MAP_CHAIN4     BIGINT,
  NO_ID_MAP_CHAIN4_KEY VARCHAR(20),
  NO_ID_MAP_CHAIN3_KEY VARCHAR(20),
  PRIMARY KEY (NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY,
               NO_ID_MAP_CHAIN3_KEY),
  FOREIGN KEY (
               NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY
    ) REFERENCES NO_ID_MAP_CHAIN3 (
                                   NO_ID_MAP_CHAIN4,
                                   NO_ID_MAP_CHAIN4_KEY
    )
);

CREATE TABLE NO_ID_MAP_CHAIN1
(
  ONE_VALUE             VARCHAR(20),
  NO_ID_MAP_CHAIN4     BIGINT,
  NO_ID_MAP_CHAIN4_KEY VARCHAR(20),
  NO_ID_MAP_CHAIN3_KEY VARCHAR(20),
  NO_ID_MAP_CHAIN2_KEY VARCHAR(20),
  PRIMARY KEY (NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY,
               NO_ID_MAP_CHAIN3_KEY,
               NO_ID_MAP_CHAIN2_KEY),
  FOREIGN KEY (
               NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY,
               NO_ID_MAP_CHAIN3_KEY
    ) REFERENCES NO_ID_MAP_CHAIN2 (
                                   NO_ID_MAP_CHAIN4,
                                   NO_ID_MAP_CHAIN4_KEY,
                                   NO_ID_MAP_CHAIN3_KEY
    )
);

CREATE TABLE NO_ID_MAP_CHAIN0
(
  ZERO_VALUE            VARCHAR(20),
  NO_ID_MAP_CHAIN4     BIGINT,
  NO_ID_MAP_CHAIN4_KEY VARCHAR(20),
  NO_ID_MAP_CHAIN3_KEY VARCHAR(20),
  NO_ID_MAP_CHAIN2_KEY VARCHAR(20),
  NO_ID_MAP_CHAIN1_KEY VARCHAR(20),
  PRIMARY KEY (NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY,
               NO_ID_MAP_CHAIN3_KEY,
               NO_ID_MAP_CHAIN2_KEY,
               NO_ID_MAP_CHAIN1_KEY),
  FOREIGN KEY (
               NO_ID_MAP_CHAIN4,
               NO_ID_MAP_CHAIN4_KEY,
               NO_ID_MAP_CHAIN3_KEY,
               NO_ID_MAP_CHAIN2_KEY
    ) REFERENCES NO_ID_MAP_CHAIN1 (
                                   NO_ID_MAP_CHAIN4,
                                   NO_ID_MAP_CHAIN4_KEY,
                                   NO_ID_MAP_CHAIN3_KEY,
                                   NO_ID_MAP_CHAIN2_KEY
    )
);

DROP TABLE IF EXISTS VERSIONED_AGGREGATE;

CREATE TABLE VERSIONED_AGGREGATE
(
  ID BIGINT IDENTITY PRIMARY KEY,
  VERSION BIGINT
);


DROP TABLE IF EXISTS WITH_LOCAL_DATE_TIME;

CREATE TABLE WITH_LOCAL_DATE_TIME
(
  ID BIGINT PRIMARY KEY,
  TEST_TIME datetime2(7)
);

DROP TABLE IF EXISTS WITH_ID_ONLY;

CREATE TABLE WITH_ID_ONLY
(
  ID BIGINT IDENTITY PRIMARY KEY
);

DROP TABLE IF EXISTS WITH_INSERT_ONLY;

CREATE TABLE WITH_INSERT_ONLY
(
  ID BIGINT IDENTITY PRIMARY KEY,
  INSERT_ONLY VARCHAR(100)
);

DROP TABLE MULTIPLE_COLLECTIONS;
DROP TABLE MAP_ELEMENT;
DROP TABLE LIST_ELEMENT;
DROP TABLE SET_ELEMENT;

CREATE TABLE MULTIPLE_COLLECTIONS
(
    ID BIGINT IDENTITY PRIMARY KEY,
    NAME VARCHAR(100)
);

CREATE TABLE SET_ELEMENT
(
    MULTIPLE_COLLECTIONS BIGINT,
    NAME VARCHAR(100)
);

CREATE TABLE LIST_ELEMENT
(
    MULTIPLE_COLLECTIONS BIGINT,
    MULTIPLE_COLLECTIONS_KEY INT,
    NAME VARCHAR(100)
);

CREATE TABLE MAP_ELEMENT
(
    MULTIPLE_COLLECTIONS BIGINT,
    MULTIPLE_COLLECTIONS_KEY VARCHAR(10),
    NAME VARCHAR(100)
);

DROP TABLE BOOK;
DROP TABLE AUTHOR;

CREATE TABLE AUTHOR
(
    ID BIGINT IDENTITY PRIMARY KEY
);

CREATE TABLE BOOK
(
    AUTHOR BIGINT,
    NAME VARCHAR(100)
);
