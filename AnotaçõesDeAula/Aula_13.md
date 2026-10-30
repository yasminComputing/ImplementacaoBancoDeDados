### Aula 13 - Dia 30.10.2026
O que foi visto na aula passada:
- TRIGGER
    - DML: INSERT, UPDATE E DELETE
        - E.C.A: evento , condição e ação
    - AFTER OU FOR: OCORRE FINAL NA TRANSAÇÃO, OU SEJA, JÁ TENHO OS DADOS/ALTERAÇÃO NO BANCO SÓ FALTANDO REALIZAR OFICIALMENTE AS ALTERAÇÕES
    - INSTEAD OF
    - INSERTED
    - DELETED
    - **UPDATED (colunaA): RETORNA VERDADEIRO OU FALSE, CASO FOR ALTERADO RETORNA VERDADEIRO E CASO NÃO FALSO**
- VIEWS
    - TABELA VIRTUAL
    - CONSULTA SQL

---
## Diferença entre AFTER e INSTEAD OF (Triggers)
A principal diferença entre AFTER e INSTEAD OF está no momento em que o trigger é executado e na sua relação com a operação que o disparou.

-  **AFTER (Depois)**: O trigger é executado somente depois que a operação no banco de dados foi concluída com sucesso (INSERT, UPDATE ou DELETE).Quando utilizar: quando deseja executar uma ação complementar após uma alteração na tabela.

```text
Exemplo: após cadastrar um novo cliente, registrar essa operação em uma tabela de auditoria ou atualizar um histórico.
```

- **INSTEAD OF (No lugar de)**: O trigger é executado no lugar da operação original, ou seja, substitui a ação que seria realizada no banco de dados.Quando utilizar: quando deseja controlar, modificar ou personalizar como uma operação será executada.

```text
Exemplo: ao tentar inserir dados em uma VIEW, o trigger recebe a operação e realiza os INSERTs necessários nas tabelas de origem.
```

3. Comparação prática
| AFTER | INSTEAD OF |
|---|---|
| Executa depois da operação original. | Executa no lugar da operação original. |
| A operação original já foi realizada. | A operação original não é executada automaticamente. |
| Utilizado para ações complementares. | Utilizado para substituir ou controlar operações. |
| Exemplo: registrar alterações em uma auditoria. | Exemplo: permitir INSERT em uma VIEW. |

4. Resumindo para memorizar
**AFTER:** primeiro o banco realiza a operação, depois executa o trigger.

**INSTEAD OF:** o banco executa o trigger no lugar da operação original.

> Dica: use AFTER quando quiser fazer algo depois de uma alteração e INSTEAD OF quando quiser definir como a alteração deve acontecer, substituindo a operação padrão.

----
## Restrição de Integridade
A integridade de dados é a manutenção e garantia da consistência e precisão dos dados, sendo aspecto crítico. A integridade é atingida por meio da aplicação de **restrições de integridade**.

**DECLARATIVA:** define restrições de consistência diretamente na estrutura das tabelas usando comandos DDL no SQL. Dessa forma, o próprio banco de dados automatiza a validação dos dados por meio de chaves (PK e FK), obrigatoriedade de campos (NOT NULL) e tipos de dados.

**PROCEDURAL:** procedural valida os dados por meio de códigos programados diretamente no banco, como triggers, stored procedures e assertions. Essa abordagem traduz as regras de negócio do cliente em rotinas automatizadas, geralmente desenvolvidas por analistas ou programadores especialistas no SGBD.

## Integridade de DOMINIO
As restrições de domínio especificam que dentro da definição definida os valores não podem ultrapassar. Por exemplo: cadastrar produtos que aceita valores negativos ou ficar zerado.ESSE TIPO DE INTEGRIDADE SEMPRE VAI SER UTILIZADO EM UM TRIGGER.

## Integridade de REFERENCIAL
Assegura que valores de uma coluna em uma tabela são válidos baseados nos valores em uma outra tabela relacionada. 
```text
Exemplo: Se um produto de ID 435 foi cadastrado em um tabela de Vendas,então um produto com o ID 435 deve existir na tabela de Produtos relacionada.
```

**ATUALIZAÇÃO E EXCLUSÃO:** se um registro for excluído em uma tabela, então os registros relacionados da tabela, o proprio banco indicará erro, pois não pode apagar dados que estão relacionados na tabela. A partir daí dentra o conceito `CASCADE`:
- Se um registro for excluído em uma tabela (operações DELETE e TRUNCATE), então os registros relacionados em outras tabelas que o referenciam talvez precisem ser excluídos. Caso contrário ocorrerá erro. O mesmo se dá com a atualização de registros (operação UPDATE).
    - on delete cascade
    - on update cascade

---

## Integridade de VAZIO
Se a coluna vai aceitar null ou not null.

---

## Integridade de CHAVE
Os valores inseridos na coluna de chave primária (PK) devem ser sempre únicos, não admitindo-se repetições nesses valores.Desta forma, as tuplas (registros) serão sempre distintas. Os valores de chave primária também não podem ser nulos.

---

## Integridade definida pelo USUÁRIO
O  usuário permite definir regras comerciais que não se encaixam em outras categorias de integridade. Todas as categorias de integridade oferecem suporte à integridade definida pelo usuário.

---

## Praticando
Quando quiser declarar unique pode utilizar o CONSTRAINT fica mais usual
```sql
CREATE DATABASE LOJA;
GO
USE LOJA;
GO

GO
CREATE TABLE CATEGORIA(
	id INT PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	CONSTRAINT uq_categoria_nome UNIQUE (nome)
);

CREATE TABLE FORNECEDOR(
	id INT PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	telefone VARCHAR(20) NULL -- significa que pode aceitar campos vazios
);
GO
CREATE TABLE PRODUTO(
	id INT IDENTITY (100,1) PRIMARY KEY, -- identity mesma coisa que auto_incrementy 
	nome VARCHAR(80) NOT NULL,
	preco DECIMAL (10,2) NOT NULL,
	quantidade INT NOT NULL CONSTRAINT df_prod_qtde DEFAULT 0, -- se cadastrar um produto sem a quantidade vai ser colocado zero automaticamente
	situacao VARCHAR(10) NOT NULL DEFAULT 'Ativo', -- como não foi dados um constraint que passe um nome então não pode ser alterado depois
	id_categoria INT NOT NULL,
	id_fornecedor INT NULL,
	-- restrição para o preço produto: dentro do CHECK pode colocar qualquer operacao logica
	CONSTRAINT ck_produto_preco CHECK (preco > 0),
	CONSTRAINT ck_produto_qtde CHECK (quantidade >= 0),
	CONSTRAINT ck_produto_situacao CHECK (situacao IN ('Ativo','Inativo')),

	CONSTRAINT fk_prod_categoria 
		FOREIGN KEY (id_categoria) REFERENCES CATEGORIA (id) 
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
-- demonstrar que pode adicionar
GO
ALTER TABLE PRODUTO
ADD CONSTRAINT fk_prod_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR (id)
	ON DELETE SET NULL
	ON UPDATE CASCADE;
GO

-- Inserir alguns valores
INSERT INTO CATEGORIA (id,nome) VALUES 
	(10,'Informática'),
	(20,'Papelaria'),
	(30,'Acessorios');
INSERT INTO FORNECEDOR (id,nome,telefone) VALUES
	(1,'Distribuidora Alfa','555-6666'),
	(2,'Comercial Ltda',NULL);

INSERT INTO PRODUTO (nome,preco,quantidade,situacao,id_categoria,id_fornecedor) 
VALUES
		('Mouse sem fio',79.99,15,'Ativo',10,1),
		('Teclado USB',120,8,'Ativo',10,2),
		('Caderno',29.90,50,'Ativo',20,2),
		('Caneta',4.50,100,'Ativo',20,2);
INSERT INTO PRODUTO (nome,preco,id_categoria) 
VALUES ('Fone de ouvido',99.90,30)

SELECT * FROM PRODUTO;

INSERT INTO CATEGORIA VALUES (40,'Papelaria');-- vai dar erro, pois já tem papelaria UNIQUE KEY TEM DEFINIDO NA TABELA

-- TESTANDO CASCADE: ON UPDATE CASCADE
UPDATE CATEGORIA
SET id = 11
WHERE id = 10; -- ao executar na mensagem informa que afetou somente um linha, sendo que foi 2, POR ISSO É NECESSÁRIO TER CUIDADO COM CASCADE

-- ON DELETE SET NULL
DELETE FROM FORNECEDOR
WHERE id = 1;

-- ON DELETED CASCADE: cuidar a IA gosta de implementar CASCADE nos bancos
DELETE FROM CATEGORIA
WHERE id = 20;
SELECT * FROM CATEGORIA;
SELECT * FROM PRODUTO;
```
---
### Gerenciamento de Acessos – SQL Server
- **Segurança:** Logan.
- **Política de senha:** habilitar a opção Impor política de senha e exigir que o usuário altere a senha no primeiro acesso.
- **Funções do Servidor:** manter a função public com permissões básicas, evitando conceder acessos desnecessários para prevenir alterações indevidas, principalmente por usuários iniciantes ou estagiários.
- **Mapeamento de Usuário:** definir quais bancos de dados o usuário poderá acessar. Nas funções do banco, configurar:
    - *public:* permissões básicas.
    - *db_datareader:* permite realizar consultas (SELECT) nas tabelas e exibições do banco.

Antes de aplicar as configurações: acessar a opção SCRIPT (primeira opção) para visualizar o script SQL gerado antes de executar as alterações. Foi rodado o script e criado outra conexão no banco, no `Conectar`. 

- GRANT: concede uma permissão específica para o usuário ou função. 

- DENY: impede que o usuário realiza uma determinada ação, este comando nega explicitamente uma permissão e tem precedencia sobre GRANT.

- REVOKE: remove um GRANT OU DENY que foi dado diretamente ao usuário, depois do REVOKE, pode ainda herdar permissões de um role. 

> Se fazer um grant e depois um deny não posso novamente dar um grant, pois a negação é superior.

---
```text
Coisa que pode cair: 
    criar um usuario e pode ser permissão disso aqui...tipo ler as informações de determinado banco, db_datareader(pode ler os dados do banco).
```
```sql
GRANT SELECT, INSERT ON [dbo].[CATEGORIA] TO Juca;
GRANT SELECT ON [dbo].[FORNECEDOR] TO Juca;
GRANT SELECT ON [dbo].[PRODUTO] TO Juca;

DENY INSERT ON [dbo].[CATEGORIA] TO Juca;

REVOKE SELECT ON [dbo].[PRODUTO] TO Juca;
REVOKE INSERT ON [dbo].[PRODUTO] TO Juca;
REVOKE INSERT ON [dbo].[CATEGORIA] TO Juca;

--Query para retonar as permissões que são dadas a nível de objetos
SELECT	state_desc, prmsn.permission_name as [Permission], sp.type_desc, sp.name,
		grantor_principal.name AS [Grantor], grantee_principal.name as [Grantee]
FROM sys.all_objects AS sp
	INNER JOIN sys.database_permissions AS prmsn 
	ON prmsn.major_id = sp.object_id AND prmsn.minor_id=0 AND prmsn.class = 1
	INNER JOIN sys.database_principals AS grantor_principal
	ON grantor_principal.principal_id = prmsn.grantor_principal_id
	INNER JOIN sys.database_principals AS grantee_principal 
	ON grantee_principal.principal_id = prmsn.grantee_principal_id
WHERE grantee_principal.name = 'Juca'


--- comandos usando o usuario JUCa
SELECT * 
FROM CATEGORIA;

INSERT INTO CATEGORIA 
VALUES (66,'Drogas');

UPDATE CATEGORIA
SET nome = 'Remedios'
WHERE id = 11;

DELETE FROM CATEGORIA
WHERE id = 11;
```
