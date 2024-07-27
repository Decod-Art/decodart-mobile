# decodart-mobile

## L'interface principale
5 onglets (détaillés plus bas) :
- Vue carte
- Vue liste
- Recherche visuelle (appareil photo)
- Vue liste de parcours de visites
- Décoder à l'infini

## Vue carte
Il s'agit de visualiser les objets géolocalisés :
- les musées, églises, etc. qui contiennent des œuvres à voir,
- des œuvres directement disponibles dans la rue (e.g. une statue, une fontaine, une façade à l'architecture notable)

Lorsqu'on clique sur un pin de type musée, on ouvre la vue musée, sinon, la vue œuvre (explication plus bas).

## Vue liste

Il y a trois sous-onglets : 
- les objets présents sur la carte,
- les œuvres d'arts (en excluant les musées donc mais également des œuvres non géolocalisées car dans un musée),
- Les musées.

## La recherche visuelle

On prend en photo une œuvre et :
- Elle n'est pas reconnue et on affiche un message,
- Elle reconnue de manière unique et on l'affiche
- Elle est reconnue plusieurs fois (e.g. copie par des élèves de l'œuvre d'un maître) et on affiche la liste des choix possibles.. Cliquer sur un élément de la liste ouvre la vue de l'œuvre.

## Vue parcours

On affiche une liste de parcours de visite.

## Vue décoder à l'infini

Une vue (pas encore construite), qui permet de décoder des œuvres à l'infini.. Décoder une œuvre est expliqué dans la partie sur la vue détaillée d'une œuvre.

## Vues détaillées
### Vue parcours détaillé
On affiche une page contenant du texte, des images et des boutons. Les boutons sont des liens vers des œuvres de la base de données qu'on ouvre en vue détaillée.

### Vue musée détaillé
On affiche 1, 2 ou 3 boutons "œuvres", "expositions" et "parcours de visite" en fonction de s'il y a du contenu disponible (on n'affiche pas exposition s'il n'y a pas d'exposition). Exposition et parcours ouvrent la vue parcours. Œuvre ouvre la vue œuvre.

### Vue détaillée d'une œuvre
On ouvre l'œuvre en grand. Scroller vers la gauche fait apparaître la biographie (potentiellement avec des images) de l'artiste. Vers la droite, le contexte historique, vers le haut, une description de l'œuvre.
Cliquer sur l'œuvre fait appraître des boites et cliquer sur une boite fait apparaître une petite explication. S'il y a plusieurs images pour une œuvre, des petites flèches permettent de se déplacer sur les différentes images.

Un appuie long referme la vue (ou un clic sur "retour").

Scroller vers le haut fait apparaître la vue "décoder" (très primaire pour l'instant). Dans le cadre d'une œuvre, la vue décoder regroupe quelques questions. Dans la vue décoder à l'infini, on surfe de thème en thème.

### Décoder une œuvre
Il s'agit de questions sur une œuvre :
- une question avec plusieurs choix possibles (les choix sont des textes ou des images). La question peut-être un texte, une image, une combinaison.
- La réponse peut-être la recherche d'éléments sur une image. "Retrouvez l'objet dont la signification est ****".

## Ce qu'il manque à l'application mobile !
Je pense qu'il manque un petit menu déroulant dans la barre du haut car :
- il faut à terme accéder à une vue profil et à l'à propos.
- Les vues parcours (lorsqu'ils sont associés à un musée) et musée doivent permettre d'accéder au plan du musée.
- Améliorer les différentes vues. Par exemple, lorsqu'on affiche les collections d'un musée, on peut tenir compte du fait qu'on est justement dans un musée et que les œuvres sont réparties en salles.

## Ce qu'il manque en général
- Une application decodart-admin afin de pouvoir gérer la base de données de manière optimisée pour notre usage (ajouter des œuvres une à une ou en batch, des parcours de visites, des expositions, des musées, des questions à décoder).
- Une méthode algorithmique basée sur l'IA afin de générer des questions à décoder à l'infini (avec calibration pour ne pas générer de résultats faux)
