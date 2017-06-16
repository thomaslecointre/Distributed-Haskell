INSTALLATION COMPATIBLE WINDOWS

1) Installez la plateforme Haskell sur https:/www.haskellorg/ adaptée à votre ordinateur (version full fortement conseillée).
2) Utilisez la commande : cabal init puis cabal update.
3) Choisissez une machine de préférence avec IP fixe pour héberger le processus master et le web serveur.
4) Installez Node. JS (https://nodejs.org/en/download/) sur la machine qui héberge le processus master. Cela installe les commandes node et npm.
5) Avec la commande npm faites npm install dans le répertoire web. Cela installe les modules nécessaires au fonctionnement du serveur web.
6) Sur la machine hébergeant le serveur web et le processus master, recompilez le répertoire web/haskell avec make.cmd.
7) Lancez le processus master avec Master.exe puis lancez le serveur web avec node server.js dans le répertoire web.
8) Sur chaque machine Slave recompilez le répertoire slave avec make.cmd.
9) Installez les bibliothèques Haskell utilisées (cabal install _bibliothèque) sur chaque machine Slave.
10) Lancez le processus Slave avec Slave.exe suivi de l'adresse IP de la machine master: Ex: Slave.exe 10.11.12.13 11) Utilisez l'interface client fournie par le serveur web @ http://ip_master:8081/.

Bibliothèques Haskell utilisées (valable pour une installation haskell-platform full):
* aeson
* http-client

PROBLEMES IDENTIFIES ET CONTRAINTES

* Certaines séries, de par leur taille ou la fiabilité des données ne sont pas exploitables. The Simpson en est un exemple. Si vous rencontrez un temps de traitement qui vous paraît trop lent essayez avec une nouvelle série.
* Le logiciel se repose sur une API node js payante (https://www.npmjs.com/package/imdb-api). Néanmoins, les séries déjà téléchargées ne seront plus retéléchargées.
* Si vous rencontrez des messages d'erreurs, relancez d'abord le master, puis les Slaves. Le web serveur peut être lancé à n'importe quel moment.
* Si aucun Slave n'est disponible au moment du premier traîtement à lancer, l'ordre est sauvegardé en mémoire et n'est uniquement traîté lorsque le premier Slave s'enregistre.
* Une déconnexion quelle soit du côté Master ou Slave n'est pas gérée proprement. Il convient de relancer le Master et les Slaves dans l'ordre.