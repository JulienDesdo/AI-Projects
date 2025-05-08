# Cars_DQLN

Dans mon exploratio de l'intelligence artificielle, j'ai toujours souhaité me pencher sur une technique combinant les réseaux de neurones (**deep-learning**) et le Q-learning (**Reinforcement learning**) car le mélange des deux, donnant place aux **Deep Reinforcement Learning** *(que j'abrège en DQLN pour Deep-Q-Learning-Networks)*. 

Les **DQN** ont explosé en 2015 DeepMind a battu des records sur les jeux Atari en surpassant les humains, sans connaissance particulière du jeu [LIEN DE LA VIDEO DU RECORD]. 


J'ai donc décidé - pour comprendre ces algorithmes - de coder un jeu de voiture où l'IA devra atteindre le ligne d'arrivée. Dans ce readme j'explique les bases théoriques - et "le pourquoi du comment ?" - , et passerai en revu les principales briques du projet. 

[GIF D ILLUSTRATION] 

## Bases Théroriques 

Tout d'abord, rappelons qu'il existe différentes catégories d'algorithmes en intelligence artificielle. On distingue principalement **les modèles supervisés, non supervisés,** ainsi que certains qui se situent à la frontière entre les deux (parfois appelés **semi-supervisés** ou **par renforcement**).

- **Un modèle supervisé** apprend à partir de données annotées. Par exemple, un dataset d’images avec des labels de classes (chien, chat, etc.). L'idée est de choisir un modèle f dont on va affiner les paramètres grâce à des algorithmes d'optimisation. J'en présente certains dans cette partie du même repo : https://github.com/JulienDesdo/AI-Projects/tree/main/theory/Levenberg-Marquardt. On peut citer le deep learning comme exemple emblématique : il ajuste les poids des réseaux de neurones progressivement au fil des itérations (via des algos comme la descente de gradient). J'explique le fonctionnement standard du deep-learning dans ce rapport : theory/ADAM-MLP-Implementation/Rapport ADAM MLP-5-11.pdf. 

- **Un modèle non supervisé** n'apprend pas à partir de labels connus. Il se base uniquement sur la structure des données pour identifier des motifs ou des regroupements. Ce type d'apprentissage est souvent utilisé pour des tâches comme le clustering (voir l'optimisation mimétique, dans la partie 4 de mon rapport Monte Carlo : theory/Mont-Carlo-Algorithms/Rapport-2-14.pdf) ou la réduction de dimensionnalité (PCA, largement utilisée en traitement d'images et de signaux).

- "Entre les deux", on trouve le **reinforcement learning**. Il utilise une structure bien définie (Agent, Environnement, Reward), qui ressemble à un modèle, mais ce n’est pas aussi explicite qu’une fonction mathématique claire reliant des entrées à des sorties comme en apprentissage supervisé. L’agent apprend par essais/erreurs en interagissant avec l’environnement, et c’est cette dynamique qui le distingue des autres approches classiques.

C'est pourquoi avant de parler des réseaux de neurones renforcés, je vais parler de Q-Learning. 

### Q-Learning 

  #### Vocabulaire clé 

  [DESSINS SOURIS LABYRINTHE]
  Prenons l'exemple d'un souris dans un labirynthe. La modélisation d'un environnement RL repose sur les precepts suivants : 
  [SCHEMA AGENT, ENV, ACTION]

  Travailler en Q-Learning c'est d'abord identifier qui fait quoi dans notre cas concret par rapport aux éléments théoriques nécessaires. Ici, **l'environnement (E)** est le labirynthe car il constitue l'ensemble de toutes les case possibles. Il possède des **rewards (R)** (fromage) et des **malus** (éclair). L'agent est la souris qui se déplace dans le labyrinthe et a quatre options possibles (**actions (A)**) qu'elle peut effectuer sur l'environnement (si celui ci le permet) : aller en bas, haut, gauche, droite. Ce schéma est la base de la théorie du RL. L'idée est que l'agent va explorer son environnement et chercher à cumuler une maximum de points (reward) en evitant les malus. Le but ultime serait de chercher le "largets accumulted reward over a sequence of actions". Et du coup on peut voir le reward comme une indication à l'agent s'il est en train de réussir sa mission ou non ("Indication of agent performance"). 
  Pour faire ça on fournit des données (**observations**) à la souris pour mettons qu'elle sache ce qu'il y a sur les cases adjacentes. ******************** Que se passe t il autour de l'agent ? - mais est ce seulement les cases adjcentes ou un champ autour ? ça depend du jeu c'est ça ??? **************
  
  L'environnement peut être assimilé à une matrice où chaque case du labirynthe est un element de la matrice. Et un element de cette matrice, c'est à dire une case sur laquelle se trouve la souris, et un **état** ou **state (S)**.
***********************VERIFIER SI ENV = SET OF STATES + MATRIX OF TRANSITION ou ENV = SET OF STATES + REWARDS... BREF vérifier les def precise et affiner. QUOI . !!!! ********************
  
  #### 3 Chaines de Markov 

**1° Markov Process (MP)** <br>

Pour réussir à ce que la souris prenne un décision sur la case sur laquelle elle doit aller à partir de celle où elle se trouve, on peut attribuer des probabilités selon qu'il est bon ou mauvais de s'y rendre. Notre systeme est en fait une **machine à état** dans laquel on passe d'un état à un autre grâce à une certaine probabilité : ce sont les MARKOV PROCESS. Voici un exemple général :  
***********************VERIFIER MARKOV PROCESS j'ai l'impression de donenr une définition impropre. ******************************************

[SCHEMA MARKOV AVEC PROBAS]

Chaque cercle est un état, pour la souris ce serait un position/case dans le labirynthe. 

Naturellement, puisque le passage d'un état à un autre se fait en probabilités, on voit que l'on peut regrouper ces probabilités dans une matrice qui décrit totalement le système précédent. 

[SCHEMA MATRICE CORRESPONDANTE]
On appelle de cela la **matrice de probabilité (P)** du système. On pourrait donc dire que le systeme c'est : **l'ensemble des états (S) & la matrice de transistion d'état (P)**

Precisions de vocabulaire : **une chaine de markov** (ensemble d'états liés entre eux : state1 -> state2 -> ... -> stateN) ; **History** : Séquence d'obersation à travers le temps (exemple : [Chat, Ordinateur, Maison, Chat, Chat, Ordinateur...]) ; **Episode** :  extraire l'observation de l'état de transition ; 

**2° Markov Reward Process (MRP)** <br>

Seulement, le probleme principal de cette méthode est qu'il n'y aucune prévoyance. En effet, si la souris a le choix entre un éclair en haut et un fromage en bas. Mais que dans le premier cas, l'éclair est suivi de 100 fromages et dans l'autre suivi de 100 éclair. La souris choisira un fromage et 100 eclair. Ce qui donne une souris grillée.<br>
C'est pouquoi on introduit les **MARKOV REWARD PROCESS**. On introduit une variable aléatoire qui symabolise le gain de l'agent sur une episode. Cela s'écrit : 

[FORMULE Gt avec somme] 

**γ est le facteur de prévoyance de l'agent entre 0 et 1**. Cela a pour but d'évaluer la valeur d'un état que l'on choisit en tenant compte de recompances à plus ou moins long terme. Evaluer les recompanses à long terme sur un episode c'est approcher γ de 1, sinon rapprocher γ de 0 c'est choisir le gain maximum immédiat au risque d'y perdre plus (c'est le cas précédent). La value of state V(s) s'exprime : 

[Equation V(S) = E[G | St=s]]

On peut récrier cette formule un peu abstraire en une qui s'applique directement au cas du système à état : <br>
[V(s)=R(s)+γs′∑​P(s′∣s)V(s′)] 

Il s'agit de l'**équation de Bellman simplifiée pour le cas MRP (markov reward process)**. En analysant la formule on voit bien que tout notre procédé revient à obtenir le systeme suivant : 
[schema MARKOV avec probas et reward]
[schema matrix of P ; matrix of R]

**Notre systeme MRP se formule (S,P,R,γ)** <br>

Voici un **exemple** pour être un peu didactique : <br>
États : S={A,B}, R(A)=5, R(B)=10, P(A∣A)=0.7, P(B∣A)=0.3, P(A∣B)=0.4, P(B∣B)=0.6. En appliquant Bellamn MRP, on a : 
V(A)=5+0.9×[0.7V(A)+0.3V(B)] <br>
V(B)=10+0.9×[0.4V(A)+0.6V(B)] <br>

**3° Markov Decision Process (MDP)** <br>



On peut d'instinct remarquer un dernier probleme ? Comment explorer correctement son environnement, dois je en tant que souris, explorer ou exploiter le peu que j'ai exploré ? C'est tout le dilemne de l'agent qui doit à la fois posséder des données pour pouvoir prédire ensuite mais en même temps,
   La solution consiste en fait à predire la solution en fonction de calcul de Q-value, et de changer la manière dont on choisit ses valeurs à mesure que l'on explore son environnemnt : la selection d'un Q-value s'appelle une politique. Trouver les politique optimale c'est obtenir pi*. On est là en plein de un schéma decisionnel : les markov decisions process. Notre systeme est une matrice à trois dimensions : la matrice d'état auquel on adjoint nos actions. 

(bon des choses à reprécciser!).   
-> probleme d'evolution des actions resolus par decisions process, là où les actions sont figés dans le cas du reward process. 

  #### Q-Tables, Bellman Equation, Politiques, Algorithme


  
  #### Limites du Q-Learning 

  Dans le cas de notre jeu de voiture, 
  Environnement trop grand
  Généralisation impossible
  Impossibilité de traiter des entrées complexes

### Deep-Q-Networks 

Enumeration des etapes, lien vers video. 1,...10. Policy Netowrk (train), Target Network, Q-Values... 

## Programme

Concretement : Libs de reinforcement, stable baseline pour les réseaux de neurones. 
Diagramme de classes ? 
Fonctionnalités. 
Explication code + Générer eventuellement docs (doxygen?) du script. 

