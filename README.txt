INSTALLATION COMPATIBLE WINDOWS

1) Installez la plateforme haskell sur https://www.haskell.org/ adaptée à votre ordinateur (version full fortement conseillée).
2) Utilisez la commande : cabal init puis cabal update.
3) Choisissez une machine de préférence avec IP fixe pour héberger le processus Master et le web serveur.
4) Installez Node.JS (https://nodejs.org/en/download/) sur la machine qui herberge le processus Master. Cela installe les commandes node et npm.
5) Avec la commande npm faites npm install dans le repertoire web. Cela installe les modules nécessaires au fonctionnement du server web.
6) Sur la machine herbergeant le serveur web et le processus Master, recompilez le repertoire web/haskell avec make.cmd.
7) Lancez le processus Master avec Master.exe puis lancez le serveur web avec node server.js dans le repertoire web.
8) Sur chaque machine Slave recompilez le repertoire slave avec make.cmd.
9) Installez les bibliothèques haskell utilisées (cabal install _bibliothèque) sur chaque machine Slave.
10) Lancez le processus Slave avec Slave.exe suivi de l'adresse IP de la machine Master: Ex: Slave.exe 10.11.12.13
11) Utilisez l'interface client fournie par le serveur web @ http://ip_master:8081/.


Blibliothèques haskell à installer (valable pour une installation haskell-platform full):

* aeson
* http-client