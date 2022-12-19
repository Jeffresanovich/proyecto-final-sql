USE ADMINISTRACION_COMPUTADORAS;

-- VISTA 1:  LISTADO DE DONADORES DEL AÑO 2021 QUE TENIAN UN PRCESADOR 'core i5'
CREATE OR REPLACE VIEW VW_DONADORES_ANIO2021_CON_COREI5 AS
(SELECT DONADORES.id_donador,CONCAT(nombre,' ',apellido) AS nombre_completo, fecha_donacion,condicion,tipo, micro,mother,ram,rom
FROM DONADORES 
INNER JOIN PERSONAS ON DONADORES.dni_persona = PERSONAS.dni_persona
INNER JOIN PC_DONADAS ON DONADORES.id_donador = PC_DONADAS.id_donador
WHERE 	YEAR(fecha_donacion) = '2021' AND
		micro LIKE '%core i5%'
ORDER BY DONADORES.id_donador);
-- SELECT * FROM VW_DONADORES_ANIO2021_CON_COREI5


-- VISTA 2: LISTAR PC DISPONIBLES PARA ENTREGAR, CLASIFICADAS POR TIPO
CREATE OR REPLACE VIEW VW_PC_DISPONIBLES_POR_TIPO AS
(SELECT tipo, COUNT(tipo) AS cant
FROM PC_DONADAS
INNER JOIN PC_REPARADAS ON PC_DONADAS.id_pc_donada = PC_REPARADAS.id_pc_donada
LEFT JOIN ENTREGAS ON PC_REPARADAS.id_pc_reparada = ENTREGAS.id_pc_reparada
WHERE 	ENTREGAS.id_entrega IS NULL 
AND 	PC_REPARADAS.estado <> 'baja'
GROUP BY PC_DONADAS.tipo);
-- SELECT * FROM VW_PC_DISPONIBLES_POR_TIPO


-- VISTA 3: CANTIDAD DE TECNICOS POR TALLER
CREATE OR REPLACE VIEW VW_TECNICOS_POR_TALLER AS
(SELECT nombre AS nombre_taller ,COUNT(nombre) AS cant_tecnicos
FROM TALLERES
INNER JOIN TECNICOS ON TALLERES.id_taller = TECNICOS.id_taller
GROUP BY nombre);
-- SELECT * FROM VW_TECNICOS_POR_TALLER

-- VISTA 4: CARACTERISTICAS DE LAS COMPUTADORAS DISPONIBLES PARA DONAR
CREATE OR REPLACE VIEW VW_PC_DISPONIBLE AS
(SELECT id_pc_donada,condicion,micro,mother,ram,rom,pantalla
FROM PC_DONADAS
WHERE id_pc_donada NOT IN (
					SELECT PC_REPARADAS.id_pc_donada 
						FROM PC_REPARADAS 
						WHERE estado = 'baja'
                    UNION
					SELECT PC_REPARADAS.id_pc_donada
						FROM PC_REPARADAS
						INNER JOIN ENTREGAS ON PC_REPARADAS.id_pc_reparada = ENTREGAS.id_pc_reparada));
-- SELECT * FROM VW_PC_DISPONIBLE

-- VISTA 5: SOLICITUDES PENDIENTES DE EVALUACION
CREATE OR REPLACE VIEW VW_SOLICITUDES_PENDIENTES_EVALUACION AS
(SELECT nombre, apellido, fecha_solicitud, proposito-- , fecha_evaluacion, comentario
FROM PERSONAS
INNER JOIN SOLICITANTES ON  PERSONAS.dni_persona = SOLICITANTES.dni_persona
INNER JOIN SOLICITUDES ON SOLICITANTES.id_solicitante = SOLICITUDES.id_solicitante
LEFT JOIN EVALUACIONES ON SOLICITUDES.id_solicitud = EVALUACIONES.id_solicitud
WHERE id_evaluacion IS NULL);
-- SELECT * FROM VW_SOLICITUDES_PENDIENTES_EVALUACION