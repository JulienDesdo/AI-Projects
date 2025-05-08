# 🚗 Cars_DQLN

Dans mon exploratio de l'intelligence artificielle, j'ai toujours souhaité me pencher sur une technique combinant les réseaux de neurones (**deep-learning**) et le Q-learning (**Reinforcement learning**) car le mélange des deux, donnant place aux **Deep Reinforcement Learning** *(que j'abrège en DQLN pour Deep-Q-Learning-Networks)*. 

Les **DQN** ont explosé en 2015 DeepMind a battu des records sur les jeux Atari en surpassant les humains, sans connaissance particulière du jeu [LIEN DE LA VIDEO DU RECORD]. 


J'ai donc décidé – pour mieux comprendre ces algorithmes – de développer un jeu de voiture où l'IA doit atteindre une ligne d'arrivée. Ce README explique les bases théoriques, le "pourquoi du comment", puis passe en revu les principales briques du projet.

[GIF D ILLUSTRATION] 

---

## Bases Théroriques 

Tout d'abord, rappelons qu'il existe différentes catégories d'algorithmes en intelligence artificielle. On distingue principalement **les modèles supervisés, non supervisés,** ainsi que certains qui se situent à la frontière entre les deux (parfois appelés **semi-supervisés** ou **par renforcement**).

- **Un modèle supervisé** apprend à partir de données annotées. Par exemple, un dataset d’images avec des labels de classes (chien, chat, etc.). L'idée est de choisir un modèle f dont on va affiner les paramètres grâce à des algorithmes d'optimisation. J'en présente certains dans cette partie du même repo : https://github.com/JulienDesdo/AI-Projects/tree/main/theory/Levenberg-Marquardt. On peut citer le deep learning comme exemple emblématique : il ajuste les poids des réseaux de neurones progressivement au fil des itérations (via des algos comme la descente de gradient). J'explique le fonctionnement standard du deep-learning dans ce rapport :  https://github.com/JulienDesdo/AI-Projects/tree/main/theory/ADAM-MLP-Implementation/Rapport ADAM MLP-5-11.pdf. 

- **Un modèle non supervisé** n'apprend pas à partir de labels connus. Il se base uniquement sur la structure des données pour identifier des motifs ou des regroupements. Ce type d'apprentissage est souvent utilisé pour des tâches comme le clustering (voir l'optimisation mimétique, dans la partie 4 de mon rapport Monte Carlo :  https://github.com/JulienDesdo/AI-Projects/tree/main/theory/Mont-Carlo-Algorithms/Rapport-2-14.pdf) ou la réduction de dimensionnalité (PCA, largement utilisée en traitement d'images et de signaux).

- "Entre les deux", on trouve le **reinforcement learning**. Il utilise une structure bien définie (Agent, Environnement, Reward), qui ressemble à un modèle, mais ce n’est pas aussi explicite qu’une fonction mathématique claire reliant des entrées à des sorties comme en apprentissage supervisé. L’agent apprend par essais/erreurs en interagissant avec l’environnement, et c’est cette dynamique qui le distingue des autres approches classiques.

C'est pourquoi avant de parler des réseaux de neurones renforcés, je vais parler de Q-Learning. 

### Q-Learning 

   
  #### *Vocabulaire clé*
  <br>

  [DESSINS SOURIS LABYRINTHE] <br>
  Prenons l'exemple d'un souris dans un labyrinthe. La modélisation d'un environnement RL repose sur les precepts suivants : 
  [SCHEMA AGENT, ENV, ACTION] <br>

  Travailler en Q-Learning c'est d'abord identifier qui fait quoi dans notre cas concret par rapport aux éléments théoriques nécessaires. Ici, **l'environnement (E)** est le labyrinthe car il constitue l'ensemble de toutes les case possibles. Il possède des **rewards (R)** (fromage) et des **malus** (éclair). L'agent est la souris qui se déplace dans le labyrinthe et a quatre options possibles (**actions (A)**) qu'elle peut effectuer sur l'environnement (si celui ci le permet) : aller en bas, haut, gauche, droite. Ce schéma est la base de la théorie du RL. L'idée est que l'agent va explorer son environnement et chercher à cumuler un maximum de points (reward) en evitant les malus. Le but ultime serait de chercher le "largets accumulted reward over a sequence of actions". Et du coup on peut voir le reward comme une indication à l'agent s'il est en train de réussir sa mission ou non ("Indication of agent performance"). 
  Pour faire ça on fournit des données (**observations**) à la souris pour qu'elle sache ce qu'il y a sur les cases adjacentes. <br> 
  
 * **Note** : L'observation peut être juste pour les cases adjacentes ou un champ de vision plus large, ça depend du design du jeu. Dans un labyrinthe simple, c'est souvent les cases adjacentes. Dans les jeux plus complexes (ex: vision 3D), ça peut être plus large. En RL classique, cela revient à connaître tout le labyrinthe (ce qu'il y a sur chaque case). Mais il existe aussi le RL partiellement observable (POMDP) pour une observabilité réduite.* <br>
  
L'environnement peut être représenté sous forme d'une **matrice**, où chaque case du labyrinthe correspond à un élément unique. Chaque élément de cette matrice — c’est-à-dire chaque case sur laquelle la souris peut se trouver — définit un **état** ou **state (S)**.  

En pratique, l'environnement englobe non seulement l'ensemble des états accessibles, mais aussi les règles du jeu : c'est-à-dire quelles actions sont possibles à partir de chaque état, comment l'agent peut évoluer après une action, et quelles récompenses il reçoit en fonction des choix effectués. Cette structure globale permet de modéliser de manière complète l'interaction entre l'agent et son monde virtuel, même si, pour l'instant, on se concentre simplement sur la représentation des états via la matrice du labyrinthe.
   <br>
  #### *Chaines de Markov* 
  <br>

**1° Markov Process (MP)** <br>

Pour que la souris décide vers quelle case aller à partir de sa position actuelle, on peut modéliser la dynamique de ses déplacements sous forme de probabilités : par exemple, quelle est la probabilité qu’elle atteigne telle ou telle case après une action donnée ? Notre système devient alors **une machine à états** où l’on passe d’un état à un autre selon certaines règles probabilistes : c’est ce qu’on appelle un **processus de Markov**. Voici un schéma : 

[SCHEMA MARKOV AVEC PROBAS]

Chaque cercle est un état, pour la souris ce serait un position/case dans le labyrinthe. 

Naturellement, puisque le passage d'un état à un autre se fait en probabilités, on voit que l'on peut regrouper ces probabilités dans une matrice qui décrit totalement le système précédent. 

[SCHEMA MATRICE CORRESPONDANTE]
<br>
On appelle de cela la **matrice de probabilité (P)** du système. On pourrait donc dire que le systeme c'est : **l'ensemble des états (S) & la matrice de transistion d'état (P)**
<br>
Precisions de vocabulaire : 
- **Chaine de markov** : ensemble d'états liés entre eux : state1 -> state2 -> ... -> stateN) ; 
- **History** : Séquence d'obersation à travers le temps (exemple : [A, B, C, A, A, B...]) ; 
- **Episode** :  extraire l'observation de l'état de transition ;  

**2° Markov Reward Process (MRP)** <br>

Seulement, le probleme principal de cette méthode est qu'il n'y a aucune prévoyance. En effet, si la souris a le choix entre un éclair en haut et un fromage en bas. Mais que dans le premier cas, l'éclair est suivi de 100 fromages et dans l'autre suivi de 100 éclairs. La souris choisira un fromage et 100 eclairs. Ce qui donne une souris grillée.<br>
C'est pouquoi on introduit les **MARKOV REWARD PROCESS**. On introduit une variable aléatoire qui symabolise le gain de l'agent sur une episode. Cela s'écrit : 

[FORMULE Gt avec somme] 

**γ est le facteur de prévoyance de l'agent entre 0 et 1**. Cela a pour but d'évaluer la valeur d'un état que l'on choisit en tenant compte de recompances à plus ou moins long terme. Evaluer les recompanses à long terme sur un episode c'est approcher γ de 1, sinon rapprocher γ de 0 c'est choisir le gain maximum immédiat au risque d'y perdre plus (c'est le cas précédent). La value of state V(s) s'exprime : 

[Equation V(S) = E[G | St=s]]

On peut réécrire cette formule un peu abstraite en une qui s'applique directement au cas du système à état : <br>
[V(s)=R(s)+γs′∑​P(s′∣s)V(s′)] 

Il s'agit de l'**équation de Bellman simplifiée pour le cas MRP (markov reward process)**. En analysant la formule on voit bien que tout notre procédé revient à obtenir le systeme suivant : 
<br>
[schema MARKOV avec probas et reward]
<br>
[schema matrix of P ; matrix of R]

**Notre systeme MRP se formule (S,P,R,γ)** <br><br>

Voici un **exemple** pour être un peu didactique : <br>
États : S={A,B}, R(A)=5, R(B)=10, P(A∣A)=0.7, P(B∣A)=0.3, P(A∣B)=0.4, P(B∣B)=0.6. 
<br>
En appliquant Bellamn MRP, on a : 

V(A)=5+0.9×[0.7V(A)+0.3V(B)] <br>
V(B)=10+0.9×[0.4V(A)+0.6V(B)] <br>

**3° Markov Decision Process (MDP)** <br>



On peut d'instinct remarquer un dernier probleme ? Comment explorer correctement son environnement, dois je en tant que souris, explorer ou exploiter le peu que j'ai exploré ? C'est tout le dilemne de l'agent qui doit à la fois posséder des données pour pouvoir prédire ensuite mais en même temps,
   La solution consiste en fait à predire la solution en fonction de calcul de Q-value, et de changer la manière dont on choisit ses valeurs à mesure que l'on explore son environnemnt : la selection d'un Q-value s'appelle une politique. Trouver les politique optimale c'est obtenir pi*. On est là en plein de un schéma decisionnel : les markov decisions processes. Notre systeme est une matrice à trois dimensions : la matrice d'état auquel on adjoint nos actions. 

(bon des choses à reprécciser!).   
-> probleme d'evolution des actions resolus par decisions process, là où les actions sont figés dans le cas du reward process. 
<br>

  #### Q-Tables, Bellman Equation, Politiques, Algorithme
<br> <br>


  #### Limites du Q-Learning 
  <br> 

  Dans le cas de notre jeu de voiture, 
  Environnement trop grand
  Généralisation impossible
  Impossibilité de traiter des entrées complexes



### Deep-Q-Networks 

Enumeration des etapes, lien vers video. 1,...10. Policy Netowrk (train), Target Network, Q-Values... 

---

## Programme

Concretement : Libs de reinforcement, stable baseline pour les réseaux de neurones. 
Diagramme de classes ? 
Fonctionnalités. 
Explication code + Générer eventuellement docs (doxygen?) du script. 

