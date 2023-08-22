/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	date_of_birth DATE NOT NULL,
	escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL NOT NULL
);

ALTER TABLE animals ADD species VARCHAR(100);

-- DAY 3

CREATE TABLE owners (
	id SERIAL NOT NULL PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	age INT NOT NULL
);

CREATE TABLE species (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD species_id INT REFERENCES species (id);
ALTER TABLE animals ADD owner_id INT REFERENCES owners (id);

-- DAY 4

CREATE TABLE vets (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INT NOT NULL,
	date_of_graduation DATE NOT NULL
);

CREATE TABLE specializations (
	id SERIAL NOT NULL PRIMARY KEY,
	vets_id INT REFERENCES vets (id),
	species_id INT REFERENCES species (id)
);

CREATE TABLE visits (
	id SERIAL NOT NULL PRIMARY KEY,
	vets_id INT REFERENCES vets (id),
	animals_id INT REFERENCES animals (id),
	date_of_visit DATE NOT NULL
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);