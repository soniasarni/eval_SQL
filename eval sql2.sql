create database immobilier;
use immobilier;

create table logement (
idLogement int auto_increment primary key,
type varchar (50),
ville varchar (50),
prix int,
superficie int,
categorie varchar(50));


create table agence(
idAgence int auto_increment primary key,
nomA varchar (50),
adresse varchar (50));


create table logement_agence(
idLogementAgence int auto_increment primary key,
idAgence int,
idLogement int,
frais int);


create table personne(
idPersonne int auto_increment primary key,
nomP varchar (50),
prenomP varchar (50),
email varchar (150) NOT NULL);

create table logement_personne(
idLogementPersonne int auto_increment primary key,
idPersonne int,
idLogement int);



create table demande (
idDemande int auto_increment primary key,
idPersonne int,
typeD varchar (50),
ville varchar (50),
budget int,
superficie int,
categorieD varchar(50));

show tables;
# faire les liaisons
alter table logement_agence
add constraint FK_logement_agence_idlogement foreign key(idLogement)
references logement(idLogement); 

alter table logement_agence
add constraint FK_logement_agence_idAgence  foreign key(idAgence)
references agence(idAgence); 

alter table logement_personne
add constraint FK_logement_personne_idpersonne  foreign key(idpersonne)
references personne(idpersonne);

alter table logement_personne
add constraint FK_logement_personne_idLogement  foreign key(idLogement)
references Logement(idLogement); 

alter table demande
add constraint FK_demande_idPersonne foreign key(idPersonne)
references personne(idPersonne);

#exercice2
call PS_ajout_agence;
call PS_ajout_Demande;
call PS_ajout_logement;
call PS_ajout_personne;
call PS_ajout_logement_agence;
call PS_logement_personne;
#exercice3
#Affichez le nom des agences
SELECT nomA FROM agence;

#Affichez le numéro de l’agence « Orpi »
select idAgence from agence where nomA = "orpi"; 

#3. Affichez le premier enregistrement de la table logement
select * from logement limit 1;

#4 Affichez le nombre de logements (Alias : Nombre de logements)
select count(idLogement) as "Nombre de logements" from logement;

#5. Affichez les logements à vendre à moins de 150000 € dans l’ordre croissant des prix.
select * from logement 
where prix < 150000 AND categorie="vente"
order by prix;

#6. Affichez le nombre de logements à la location (alias : nombre)
select count(idLogement) as nombre from logement 
where categorie ='location';

#7. Affichez les villes différentes recherchées par les personnes demandeuses d'un logement
select  distinct ville from demande
inner join personne on personne.idPersonne= demande.idPersonne;

#8. Affichez le nombre de biens à vendre par ville
SELECT ville,count(categorie)from logement 
where categorie= 'vente' 
 group by ville;
 
#9. Quelles sont les id des logements destinés à la location ?
SELECT idLogement FROM logement 
where categorie = 'location';

#10.Quels sont les id des logements entre 20 et 30m² ?
SELECT idLogement FROM logement 
where superficie>=20 
and superficie<=30;

#11.Quel est le prix vendeur (hors frais) du logement le moins cher à vendre ? (Alias :prix minimum)
SELECT  MIN(prix) as 'prix minimum 'from logement 
inner join logement_agence
on logement.idLogement = logement_agence.idLogement; 
 
 #12.Dans quelles villes se trouve les maisons à vendre ?
 select ville from logement
 where type = 'maison';

# 13. L’agence Orpi souhaite diminuer les frais qu’elle applique sur le logement ayant l'id
#« 3 ». Passer les frais de ce logement de 800 à 730€
#select frais from  logement_agence
#alter table logement_agence  alter column idLogemnt int 3  alter column frais int 730; 

#14.Quels sont les logements gérés par l’agence « seloger »

select  idLogement from logement_agence
inner join agence
on logement_agence.idAgence = agence.idAgence 
where nomA ='seloger';

#15.Affichez le nombre de propriétaires dans la ville de Paris (Alias : Nombre)
select count(idLogementPersonne) as Nombre from logement_personne 
inner join logement 
on logement_personne.idLogement=logement.idLogement
where ville ='Paris';

#16.Affichez les informations des trois premières personnes souhaitant acheter un logement
select * from personne 
inner join demande
on personne.idPersonne=demande.idPersonne;

#17.Affichez les prénoms, email des personnes souhaitant accéder à un logement en
#location sur la ville de Paris

select prenomP,email FROM personne
inner join demande
on personne.idPersonne=demande.idPersonne
where ville="paris"
AND categorieD ='location';

#18. Si l’ensemble des logements étaient vendus ou loués demain, quel serait le
#bénéfice généré grâce aux frais d’agence et pour chaque agence (Alias : bénéfice,
#classement : par ordre croissant des gains)
select sum(frais) as benifice, nomA from logement_agence 
inner join agence
on logement_agence.idAgence= agence.idAgence
group by nomA order by sum(frais) asc;
 
#19.Affichez le prénom et la ville où se trouve le logement de chaque propriétaire
SELECT prenomP,ville from personne 
inner join logement_personne
on personne.idPersonne= logement_personne.idPersonne
inner join logement 
on logement.idLogement= logement_personne.idLogement;

/*#20.Affichez le nombre de logements à la vente dans la ville de recherche de « sarah » 
select count(idLogement)from logement 
inner join personne
on logement.idPersonne=personne.idPrersonne
inner join demande
on  demande.idPersonne=personne.idPrersonne
where nomP ='sarah'
and categorie= 'vente';*/

#exeRCICE4
#Donner les droits d’afficher et d’ajouter des personnes et logements pour l’utilisateur afpa

CREATE USER 'afpa' identified by 'test';
CREATE USER 'cda314' identified by 'test1';
grant  select,insert on personne to afpa@localhost ;
grant  select,insert on logement to afpa@localhost ;


#Donner les droits de supprimer des demandes d’achat et logements pour l’utilisateur cda314
grant delete  on demande to cda314@localhost;

#thank you very mucH !