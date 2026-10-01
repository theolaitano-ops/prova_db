create table aeronaves(
id serial primary key,
modelo varchar(100) not null,
codigo_cauda varchar(10) unique not null,
capacidade int 
)

create table pilotos(
id serial primary key,
nome varchar(100) not null,
codigo_anac varchar(6) unique not null,
horas_de_voo int 
)

create table voos(
id serial primary key,
aeronave_id int references aeronaves(id),
piloto_id int references pilotos(id),
numero_voo varchar(30) not null,
origem varchar (100) not null,
destino varchar (100) not null,
data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
status varchar(20) DEFAULT 'agendado' CHECK (status in ('agendado', 'em voo', 'concluido', 'finalizado'))
)

create table passageiros(
id serial primary key,
nome varchar(100) not null,
cpf varchar(11) unique not null,
email varchar(100) unique not null
)

create table passagens(
id serial primary key,
voo_id int references voos(id),
passageiro_id int references passageiros(id),
assento varchar(4) not null,
classe varchar(20) default 'economica' check (classe in ('econimica', 'executiva')),
valor decimal (10,2)
)

insert into aeronaves (modelo, codigo_cauda, capacidade)
values
('aviao1', 'ABC-123', '50'),
('aviao2', 'ABC-456', '57'),
('aviao3', 'ABC-789', '60'),
('aviao4', 'ABC-986', '67'),
('aviao5', 'ABC-532', '69')

insert into pilotos (nome, codigo_anac, horas_de_voo)
values
('Cleber', '123456', '70'),
('jilson', '789123','120'),
('jocaco', '867469','67'),
('zezão', '673215', '80'),
('jão', '133111', '200')

insert into passageiros (nome, cpf, email)
values
('pereira', '12345678901', 'pereiragoat@gmail.com'),
('artur', '23456789012', 'artur@gmail.com'),
('gabriel', '34567890123', 'gabriel@gmail.com'),
('melzi', '45678901234', 'melzi@gmail.com'),
('richard', '56789012345', 'richard@gmail.com')

insert into voos (numero_voo, origem, destino, status)
values
('1670000', 'São Paulo', 'Florianópolis', 'em voo'),
('1234567', 'Xique Xique Bahia', 'Casa do jocaco', 'em voo'),
('4378923', 'São Paulo', 'itajai', 'concluido'),
('5097328', 'Florianópolis', 'Japão', 'agendado'),
('1670000', 'Rio de Janeiro', 'Florianópolis', 'concluido')


insert into passagens (assento, classe, valor)
values
('12A', 'econimica', '300.00'),
('E2', 'executiva', '800.00'),
('5F', 'econimica', '300.00'),
('E6', 'executiva', '800.00'),
('10E', 'econimica', '300.00');


CREATE VIEW vw_painel_aeroporto AS
SELECT 
    v.numero_voo,
    v.data_hora,
    v.origem,
    v.destino,
    a.modelo AS modelo_aeronave,
    a.codigo_cauda,
    v.status
FROM voos v
LEFT JOIN aeronaves a ON v.aeronave_id = a.id;

CREATE VIEW vw_faturamento_por_voo AS
SELECT 
    v.id AS voo_id,
    v.numero_voo,
    v.destino,
    COUNT(p.id) AS total_passageiros,
    COALESCE(SUM(p.valor), 0.00) AS receita_total
FROM voos v
LEFT JOIN passagens p ON v.id = p.voo_id
GROUP BY v.id, v.numero_voo, v.destino;