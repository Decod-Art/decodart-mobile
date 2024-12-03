# Decod'Art
## Introduction

## Installation

## Code structure

Install into a project : 

```
#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 source_directory target_directory"
    exit 1
fi

source_directory=$1;
target_directory=$2;

rsync -av --relative "$source_directory"/. "$target_directory"
```

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
On affiche 1, 2 ou 3 boutons "œuvres", "expositions" et "parcours de visite" en fonction de s'il y a du contenu disponible (on n'affiche pas exposition s'il n'y a pas d'exposition). Exposition et parcours ouvrent la vue parcours. Œuvre ouvre la 