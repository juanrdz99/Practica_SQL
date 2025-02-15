-- Codigo Ejecutable en BigQuery
CREATE TABLE keepcoding.alumno (
  id_alumno INT64 NOT NULL,
  nombre STRING NOT NULL,
  apellido STRING NOT NULL,
  email STRING NOT NULL,
  PRIMARY KEY (id_alumno) NOT ENFORCED
);

CREATE TABLE keepcoding.bootcamp (
  id_bootcamp INT64 NOT NULL,
  nombre STRING NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  descripcion STRING,
  PRIMARY KEY (id_bootcamp) NOT ENFORCED
);

CREATE TABLE keepcoding.modulo (
  id_modulo INT64 NOT NULL,
  nombre STRING NOT NULL,
  duracion INT64 NOT NULL,
  descripcion STRING,
  PRIMARY KEY (id_modulo) NOT ENFORCED
);

CREATE TABLE keepcoding.profesor (
  id_profesor INT64 NOT NULL,
  nombre STRING NOT NULL,
  apellido STRING NOT NULL,
  email STRING NOT NULL,
  especialidad STRING,
  PRIMARY KEY (id_profesor) NOT ENFORCED
);

CREATE TABLE keepcoding.inscripcion (
  id_alumno INT64 NOT NULL,
  id_bootcamp INT64 NOT NULL,
  fecha_inscripcion DATE,
  PRIMARY KEY (id_alumno, id_bootcamp) NOT ENFORCED,
  FOREIGN KEY (id_alumno) REFERENCES keepcoding.alumno(id_alumno) NOT ENFORCED,
  FOREIGN KEY (id_bootcamp) REFERENCES keepcoding.bootcamp(id_bootcamp) NOT ENFORCED
);

CREATE TABLE keepcoding.composicion (
  id_bootcamp INT64 NOT NULL,
  id_modulo INT64 NOT NULL,
  orden INT64,
  PRIMARY KEY (id_bootcamp, id_modulo) NOT ENFORCED,
  FOREIGN KEY (id_bootcamp) REFERENCES keepcoding.bootcamp(id_bootcamp) NOT ENFORCED,
  FOREIGN KEY (id_modulo) REFERENCES keepcoding.modulo(id_modulo) NOT ENFORCED
);

CREATE TABLE keepcoding.imparte (
  id_profesor INT64 NOT NULL,
  id_modulo INT64 NOT NULL,
  rol STRING,
  PRIMARY KEY (id_profesor, id_modulo) NOT ENFORCED,
  FOREIGN KEY (id_profesor) REFERENCES keepcoding.profesor(id_profesor) NOT ENFORCED,
  FOREIGN KEY (id_modulo) REFERENCES keepcoding.modulo(id_modulo) NOT ENFORCED
);