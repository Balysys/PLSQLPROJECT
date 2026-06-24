#!/bin/bash

echo "==========================================="
echo "🔧 Configuration de l'environnement Oracle"
echo "==========================================="

echo "⏳ Attente du démarrage d'Oracle Database..."

until sqlplus -L sys/OraclePwd_2025@//localhost:1521/FREEPDB1 as sysdba <<SQL
  select 1 from dual;
  exit;
SQL
do
  echo "⏳ Attente d'Oracle..."
  sleep 10
done

echo "✅ Oracle Database est prêt !"
echo "🔧 Création des tables et insertion des données..."

sqlplus -L sys/OraclePwd_2025@//localhost:1521/FREEPDB1 as sysdba <<SQL
CONNECT hotel_admin/Hotel123@//localhost:1521/FREEPDB1;

BEGIN
    FOR c IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || c.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

CREATE SEQUENCE seq_client START WITH 1001;
CREATE SEQUENCE seq_reservation START WITH 5001;
CREATE SEQUENCE seq_journal START WITH 1;

CREATE TABLE chambre (
    numero NUMBER(4) PRIMARY KEY,
    type_ch VARCHAR2(20) CHECK (type_ch IN ('SIMPLE','DOUBLE','SUITE','FAMILIALE')),
    etage NUMBER(2),
    prix_nuit NUMBER(8,2) NOT NULL CHECK (prix_nuit > 0),
    disponible CHAR(1) DEFAULT 'O' CHECK (disponible IN ('O','N'))
);

CREATE TABLE client_hotel (
    id NUMBER(8) PRIMARY KEY,
    nom VARCHAR2(50) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    passeport VARCHAR2(20) UNIQUE,
    email VARCHAR2(100),
    vip CHAR(1) DEFAULT 'N' CHECK (vip IN ('O','N'))
);

CREATE TABLE reservation (
    id NUMBER(10) PRIMARY KEY,
    client_id NUMBER(8) REFERENCES client_hotel(id),
    chambre_no NUMBER(4) REFERENCES chambre(numero),
    date_arrivee DATE NOT NULL,
    date_depart DATE NOT NULL,
    nb_personnes NUMBER(2) DEFAULT 1,
    montant_total NUMBER(10,2),
    statut VARCHAR2(15) DEFAULT 'CONFIRMEE'
        CHECK (statut IN ('CONFIRMEE','ANNULEE','TERMINEE'))
);

CREATE TABLE journal_resa (
    id NUMBER(10) PRIMARY KEY,
    action VARCHAR2(10),
    client_id NUMBER(8),
    chambre_no NUMBER(4),
    date_action TIMESTAMP DEFAULT SYSTIMESTAMP,
    utilisateur VARCHAR2(30)
);

-- Insertion des chambres
INSERT INTO chambre VALUES (101, 'SIMPLE', 1, 80.00, 'O');
INSERT INTO chambre VALUES (102, 'SIMPLE', 1, 85.00, 'O');
INSERT INTO chambre VALUES (103, 'DOUBLE', 1, 120.00, 'O');
INSERT INTO chambre VALUES (104, 'DOUBLE', 1, 125.00, 'N');
INSERT INTO chambre VALUES (105, 'SUITE', 1, 200.00, 'O');
INSERT INTO chambre VALUES (201, 'SIMPLE', 2, 90.00, 'O');
INSERT INTO chambre VALUES (202, 'SIMPLE', 2, 95.00, 'O');
INSERT INTO chambre VALUES (203, 'DOUBLE', 2, 130.00, 'O');
INSERT INTO chambre VALUES (204, 'DOUBLE', 2, 135.00, 'O');
INSERT INTO chambre VALUES (205, 'FAMILIALE', 2, 180.00, 'O');
INSERT INTO chambre VALUES (301, 'SIMPLE', 3, 100.00, 'O');
INSERT INTO chambre VALUES (302, 'SIMPLE', 3, 105.00, 'O');
INSERT INTO chambre VALUES (303, 'DOUBLE', 3, 140.00, 'O');
INSERT INTO chambre VALUES (304, 'SUITE', 3, 220.00, 'O');
INSERT INTO chambre VALUES (305, 'FAMILIALE', 3, 190.00, 'O');
INSERT INTO chambre VALUES (401, 'SUITE', 4, 250.00, 'O');
INSERT INTO chambre VALUES (402, 'SUITE', 4, 260.00, 'O');
INSERT INTO chambre VALUES (403, 'FAMILIALE', 4, 200.00, 'O');
INSERT INTO chambre VALUES (404, 'DOUBLE', 4, 150.00, 'O');
INSERT INTO chambre VALUES (405, 'SIMPLE', 4, 110.00, 'O');
INSERT INTO chambre VALUES (501, 'SUITE', 5, 300.00, 'O');
INSERT INTO chambre VALUES (502, 'FAMILIALE', 5, 230.00, 'O');

-- Insertion des clients
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'DUPONT', 'Jean', 'AB123456', 'jean.dupont@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'MARTIN', 'Sophie', 'CD789012', 'sophie.martin@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'BERNARD', 'Pierre', 'EF345678', 'pierre.bernard@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'PETIT', 'Marie', 'GH901234', 'marie.petit@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'ROBERT', 'Lucas', 'IJ567890', 'lucas.robert@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'RICHARD', 'Emma', 'KL123456', 'emma.richard@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'DUBOIS', 'Thomas', 'MN789012', 'thomas.dubois@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'MOREAU', 'Julie', 'OP345678', 'julie.moreau@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'LAURENT', 'Nicolas', 'QR901234', 'nicolas.laurent@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'SIMON', 'Camille', 'ST567890', 'camille.simon@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'MICHEL', 'Antoine', 'UV123456', 'antoine.michel@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'LEFEBVRE', 'Laura', 'WX789012', 'laura.lefebvre@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'LEROY', 'David', 'YZ345678', 'david.leroy@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'ROUX', 'Elodie', 'AB901234', 'elodie.roux@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'DAVID', 'Alexandre', 'CD567890', 'alexandre.david@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'BERTRAND', 'Claire', 'EF123456', 'claire.bertrand@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'MORIN', 'Julien', 'GH789012', 'julien.morin@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'FOURNIER', 'Manon', 'IJ345678', 'manon.fournier@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'GIRARD', 'Benoit', 'KL901234', 'benoit.girard@email.com', 'O');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'DUPUIS', 'Sarah', 'MN567890', 'sarah.dupuis@email.com', 'N');
INSERT INTO client_hotel VALUES (seq_client.NEXTVAL, 'LAMBERT', 'Maxime', 'OP123456', 'maxime.lambert@email.com', 'N');

-- Insertion des réservations
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1001, 101, DATE '2026-07-01', DATE '2026-07-05', 1, 320.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1002, 103, DATE '2026-07-02', DATE '2026-07-08', 2, 720.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1003, 105, DATE '2026-07-05', DATE '2026-07-10', 2, 1000.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1004, 201, DATE '2026-07-08', DATE '2026-07-12', 1, 360.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1005, 203, DATE '2026-07-10', DATE '2026-07-15', 2, 650.00, 'ANNULEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1006, 205, DATE '2026-07-12', DATE '2026-07-20', 4, 1440.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1007, 301, DATE '2026-07-15', DATE '2026-07-18', 1, 300.00, 'TERMINEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1008, 303, DATE '2026-07-18', DATE '2026-07-25', 2, 980.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1009, 304, DATE '2026-07-20', DATE '2026-07-22', 2, 440.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1010, 305, DATE '2026-07-22', DATE '2026-07-30', 3, 1520.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1011, 401, DATE '2026-07-25', DATE '2026-07-28', 2, 750.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1012, 402, DATE '2026-07-28', DATE '2026-08-02', 2, 1300.00, 'ANNULEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1013, 403, DATE '2026-08-01', DATE '2026-08-08', 4, 1400.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1014, 404, DATE '2026-08-05', DATE '2026-08-10', 2, 750.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1015, 405, DATE '2026-08-08', DATE '2026-08-12', 1, 440.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1016, 501, DATE '2026-08-10', DATE '2026-08-15', 2, 1500.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1017, 502, DATE '2026-08-12', DATE '2026-08-20', 3, 1840.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1018, 102, DATE '2026-08-15', DATE '2026-08-18', 1, 255.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1019, 104, DATE '2026-08-18', DATE '2026-08-22', 2, 500.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1020, 202, DATE '2026-08-20', DATE '2026-08-25', 1, 475.00, 'CONFIRMEE');
INSERT INTO reservation VALUES (seq_reservation.NEXTVAL, 1021, 204, DATE '2026-08-22', DATE '2026-08-28', 2, 810.00, 'CONFIRMEE');

COMMIT;

PROMPT '✅ Données de test insérées !';
PROMPT '   - 22 chambres';
PROMPT '   - 21 clients';
PROMPT '   - 21 réservations';
EXIT;
SQL

echo ""
echo "==========================================="
echo "📋 Connexion :"
echo "   Utilisateur: hotel_admin"
echo "   Mot de passe: Hotel123"
echo "   Chaîne: localhost:1521/FREEPDB1"
echo "==========================================="
