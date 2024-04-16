#NIVELL 1

#EXERCICI 1
#La teva tasca és dissenyar i crear una taula anomenada "credit_card"
#que emmagatzemi detalls crucials sobre les targetes de crèdit.

USE transactions;

-- Creamos la tabla credit_card
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);

CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(20) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(20),
    pin VARCHAR(4),
    cvv VARCHAR(10),
    expiring_date DATE,
    actual_date DATE
);
	
alter table transaction
	add FOREIGN KEY FK_credit_id (credit_card_id)
    references credit_card(id);
#EXERCICI 2
#El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb el: IBAN CcU-2938.
#Es requereix actualitzar la informació que identifica un compte bancari a nivell internacional
#(identificat com "IBAN"): TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

-- Actualizamos IBAN del id Ccu-2938
UPDATE credit_card SET iban = 'R323456312213576817699999' WHERE id = 'CcU-2938';

SELECT id,iban
FROM credit_card
WHERE id = 'CcU-2938';


#EXERCICI 3
#En la taula "transaction" ingressa un nou usuari amb la següent informació:

-- Añadimos la información del user_id = '9999'
USE credit_card;
INSERT INTO credit_card (id) VALUES ('CcU-9999');

USE transactions;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) VALUES (
'108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '2024-03-05 12:30:00',         '111.11', '0');

SET FOREIGN_KEY_CHECKS = 1;

#EXERCICI 4
#Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.

-- Eliminamos la columna 'pan'
ALTER TABLE credit_card DROP COLUMN pan;

#NIVELL 2
#EXERCICI 1
#Elimina el registre amb IBAN 02C6201E-D90A-1859-B4EE-*88D2986D3B02 de la base de dades.

-- Eliminamos la ID = '02C6201E-D90A-1859-B4EE-88D2986D3B02'
DELETE FROM transaction WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT *
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

#EXERCICI 2
#La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
#S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
#Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació:
#Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia.
#Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.


CREATE VIEW VistaMarketing AS

SELECT DISTINCT c.company_name, c.phone, c.country,AVG(t.amount) as avg_trans
FROM company c
JOIN transaction t
ON c.id = t.company_id
GROUP BY c.company_name, c.phone, c.country
ORDER BY avg_trans DESC;

-- Comprobamos la vista para ver si da resultado
SELECT *
FROM VistaMarketing;

#EXERCICI 3
#Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT company_name
FROM VistaMarketing
WHERE country = 'Germany';

#NIVELL 3
#EXERCICI 1
#La setmana vinent tindràs una nova reunió amb els gerents de màrqueting.
#Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar.
#Et demana que l'ajudis a deixar els comandos executats per a obtenir les següents modificacions
#(s'espera que realitzin 6 canvis): 


USE transactions;

  -- Creamos la tabla user
CREATE INDEX idx_user_id ON transaction(user_id);

 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255),
        FOREIGN KEY(id) REFERENCES transaction(user_id)        
    );
    

-- Eliminamos la columna website de la tabla company.

ALTER TABLE company DROP COLUMN website;


-- Añadimos la columna fecha_actual a la tabla credit_card

ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE;


-- Modificamos el nombre del campo email por personal_email de la tabla user

ALTER TABLE user
CHANGE email personal_email varchar(150);

#EXERCICI 2
#L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
#ID de la transacció, Nom de l'usuari/ària, Cognom de l'usuari/ària,IBAN de la targeta de crèdit usada,
#Nom de la companyia de la transacció realitzada. Assegura't d'incloure informació rellevant de totes dues taules
#i utilitza àlies per a canviar de nom columnes segons sigui necessari.
#Mostra els resultats de la vista, ordena els resultats de manera descendent
#en funció de la variable ID de transaction.

CREATE VIEW InformeTecnico AS

SELECT t.id as transaccion_id, u.name as nombre, u.surname as apellido, cc.iban, 
c.company_name as compañía, t.timestamp as fecha_transaccion, t.declined
FROM transaction t
JOIN company c
ON c.id = t.company_id
JOIN user u
ON u.id = t.user_id
JOIN credit_card cc
ON cc.id = t.credit_card_id;

SELECT *
FROM InformeTecnico
ORDER BY transaccion_id DESC;

-- Si quisieramos hacer la selección de todos los campos a través del WHERE y AND en vez de usar JOIN
/*
SELECT t.id as transaccion_id, u.name as nombre, u.surname as apellido, cc.iban, 
c.company_name as compañía, t.timestamp as fecha_transaccion, t.declined
FROM transaction t, company c, user u, credit_card cc
WHERE c.id = t.company_id
AND u.id = t.user_id
AND cc.id = t.credit_card_id;
*/ 

SELECT DISTINCT credit_card_id 
FROM transaction;

SELECT DISTINCT id 
FROM credit_card 
WHERE id IN (SELECT DISTINCT credit_card_id FROM transaction);

SELECT t.*
FROM transaction t
LEFT JOIN credit_card c ON t.credit_card_id = c.id
WHERE c.id IS NULL;

SELECT *
FROM transaction;
