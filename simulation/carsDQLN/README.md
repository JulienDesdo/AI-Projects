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

  #### Vocabulaire 
  
  #### 3 Chaines de Markov 
  
  #### Q-Tables, Bellman Equation, Politiques, Algorithme
  
  #### Limites du Q-Learning 

### Deep-Q-Networks 

Enumeration des etapes, lien vers video. 1,...10. Policy Netowrk (train), Target Network, Q-Values... 

## Programme

Concretement : Libs de reinforcement, stable baseline pour les réseaux de neurones. 
Diagramme de classes ? 
Fonctionnalités. 
Explication code + Générer eventuellement docs (doxygen?) du script. 

