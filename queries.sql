/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = 'true' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'true';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- DAY 2

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT save_01;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO SAVEPOINT save_01;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT ROUND(AVG(weight_kg), 2) FROM animals;
SELECT CASE WHEN neutered = 't' THEN 'Neutered' ELSE 'Not Neutered' END AS neutered_status, SUM(escape_attempts) AS total_escape_attempts FROM animals GROUP BY neutered_status;
SELECT MIN(weight_kg),MAX(weight_kg),species FROM animals GROUP BY species;
SELECT ROUND(AVG(escape_attempts), 2) AS avg_escape_attempts, species FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-- DAY 3

SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';
SELECT * FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';
SELECT * FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;
SELECT COUNT(species_id) AS total_animals, species.name FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;
SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id JOIN species ON animals.species_id = species.id WHERE species.name = 'Digimon' AND owners.id = 2;
SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.id = 5 AND animals.escape_attempts = 0;
SELECT o.full_name, COUNT(a.id) AS max_animal_count FROM owners o JOIN animals a ON o.id = a.owner_id GROUP BY o.id ORDER BY max_animal_count DESC LIMIT 1;

-- DAY 4

SELECT vets.name, animals.name, visits.date_of_visit FROM animals JOIN
visits ON animals.id = visits.animals_id
JOIN vets ON visits.vets_id = vets.id
WHERE vets.name = 'William Tatcher'
GROUP BY vets.name,animals.name, visits.date_of_visit
ORDER BY visits.date_of_visit DESC;

SELECT v.name, COUNT(vi.animals_id) AS total_animals FROM vets v JOIN
visits vi ON v.id = vi.vets_id
JOIN animals a ON vi.animals_id = a.id
WHERE v.name = 'Stephanie Mendez'
GROUP BY v.name
ORDER BY total_animals;

SELECT v.name, spec.name AS speciality, v.date_of_graduation FROM vets v
LEFT JOIN specializations s ON v.id = s.vets_id
LEFT JOIN species spec ON spec.id = s.species_id;

SELECT a.name, v.name, vi.date_of_visit FROM animals a
JOIN visits vi ON a.id = vi.animals_id
JOIN vets v ON vi.vets_id = v.id
WHERE v.name = 'Stephanie Mendez' AND vi.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT a.id, a.name, COUNT(vi.date_of_visit) AS most_visit FROM animals a
JOIN visits vi ON a.id = vi.animals_id
JOIN vets v ON vi.vets_id = v.id
GROUP BY a.name, a.id
ORDER BY COUNT(vi.date_of_visit) DESC LIMIT 1;

SELECT a.name, v.name, vi.date_of_visit AS first_visit FROM animals a
JOIN visits vi ON a.id = vi.animals_id
JOIN vets v ON vi.vets_id = v.id
WHERE v.name = 'Maisy Smith'
ORDER BY first_visit LIMIT 1;

SELECT a.name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, v.name, v.age, v.date_of_graduation,
vi.date_of_visit AS recent_visit FROM animals a
JOIN visits vi ON a.id = vi.animals_id
JOIN vets v ON vi.vets_id = v.id
ORDER BY recent_visit DESC LIMIT 1;

SELECT COUNT(v.date_of_visit) AS num_visits_no_specialization
FROM visits v
JOIN animals a ON v.animals_id = a.id
LEFT JOIN specializations s ON v.vets_id = s.vets_id AND a.species_id = s.species_id
WHERE s.vets_id IS NULL;

SELECT s.name AS species_name, vt.name COUNT(*) AS num_visits
FROM visits v
JOIN animals a ON v.animals_id = a.id
JOIN species s ON a.species_id = s.id
JOIN vets vt ON v.vets_id = vt.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name, vt.name
ORDER BY num_visits DESC
LIMIT 1; 

-- Week 2
SELECT COUNT(*) FROM visits where animals_id = 4;
SELECT * FROM visits where vets_id = 2;
SELECT * FROM owners where email = 'owner_18327@mail.com';

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animals_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits WHERE vets_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners WHERE email = 'owner_18327@mail.com';

CREATE INDEX idx_animal_id ON visits (animals_id);
ANALYZE visits;
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animals_id = 4;

CREATE INDEX idx_vets_id ON visits (vets_id);
ANALYZE visits;
EXPLAIN ANALYZE SELECT id,animals_id,date_of_visit FROM visits where vets_id = 2;
CREATE INDEX idx_email ON owners (email);
ANALYZE visits;
EXPLAIN ANALYZE SELECT id,full_name FROM owners where email = 'owner_18327@mail.com';
