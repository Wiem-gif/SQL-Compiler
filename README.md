# 📘 Compilateur & Validateur de Requêtes SQL

## 🎯 Objectif

Ce projet a été réalisé dans le cadre du module de **Compilation**. Il a pour but de démontrer les étapes de conception d'un compilateur simplifié capable de **valider la syntaxe de requêtes SQL**.  
Il repose sur **Flex (Lex)** pour l’analyse lexicale, **Bison (Yacc)** pour l’analyse syntaxique, et une **interface Python (Tkinter)** pour l’interaction utilisateur.

---

## 🧠 Fonctionnalités principales

- ✅ Analyse et validation syntaxique de requêtes SQL
- 🖥️ Interface graphique conviviale (Tkinter)
- 🔢 Numérotation automatique des requêtes
- 🟢 Affichage en vert pour les requêtes valides avec icône de validation
- 🔴 Affichage en rouge pour les erreurs avec icône de croix
- 📊 Statistiques en temps réel : nombre de requêtes valides, invalides, et total
- 📄 Affichage du retour du compilateur en temps réel

---

## 🛠️ Technologies utilisées

| Composant       | Rôle                         |
|------------------|------------------------------|
| **Flex**         | Analyseur lexical SQL        |
| **Bison**        | Analyseur syntaxique SQL     |
| **C (GCC)**      | Compilation du compilateur   |
| **Python**       | Interface graphique          |
| **Tkinter**      | GUI utilisateur              |

---

## 📁 Structure du projet

```

.
├── lex.l                 # Analyseur lexical SQL
├── synt.y                # Analyseur syntaxique SQL
├── application.py        # Interface graphique (Tkinter)
├── compile.sh            # Script automatique de compilation
├── clear.sh              # Script de nettoyage
└── README.md             # Ce fichier

````

---

## 🖥️ Installation & Compilation

### ✅ Prérequis

- `flex`, `bison`, `gcc`
- Python 3.6+ avec `tkinter` installé

### 📦 Installer les dépendances

#### Sous Ubuntu/Debian :
```bash
sudo apt update
sudo apt install flex bison gcc python3 python3-pip python3-tk
````

#### Installer les bibliothèques Python :

```bash
pip3 install ttkbootstrap
```

---

### 🔧 Compilation

#### Option 1 : Utiliser le script fourni

```bash
./compile.sh
```

#### Option 2 : Compilation manuelle

```bash
flex lex.l
bison -d synt.y
gcc -o sql_parser lex.yy.c y.tab.c -lfl
```

---

## 🚀 Lancer l’application

### Interface graphique :

```bash
python3 application.py
```

---

## ✨ Fonctionnement de l’interface

1. Saisissez une requête SQL dans la zone de texte.
2. Cliquez sur **"Valider"**.
3. La requête sera :

   * ✅ **Valide** (affichée en vert)
   * ❌ **Invalide** (affichée en rouge)


---

## ✅ Syntaxe SQL prise en charge

Le compilateur supporte un sous-ensemble simplifié de SQL :

### SELECT

```sql
SELECT * FROM table;
SELECT col1, col2 FROM table WHERE col1 > 5;
```

### INSERT

```sql
INSERT INTO table VALUES (1, 'nom');
INSERT INTO table (col1, col2) VALUES (1, 'test');
```

### DELETE

```sql
DELETE FROM table WHERE condition;
```

### UPDATE

```sql
UPDATE table SET col1 = 5 WHERE col2 = 'test';
```

### CREATE

```sql
CREATE TABLE nom (id INT, nom VARCHAR);
```

---

## 📂 Fichiers générés à ignorer

Les fichiers suivants sont générés à la compilation et ne doivent **pas être versionnés** :

* `lex.yy.c`
* `y.tab.c`
* `y.tab.h`
* `sql_parser` (exécutable)

---

## 👨‍💻 Contributrice

**Wiem Iben Youssef**
Étudiante ingénieur en téléinformatique à l’ISITCOM

---

```

---


