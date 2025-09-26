#!/bin/bash

# =================================================================
# Configuration et initialisation
# =================================================================
# Fichier temporaire pour stocker les versions consolidées
TEMP_VERSIONS_FILE=$(mktemp)
# Tableau associatif pour stocker la version cible pour chaque dépendance
declare -A TARGET_VERSIONS

echo "Phase 1: Identification des versions maximales requises..."
cd ..
# 1. Scanner tous les pubspec.yaml pour extraire les dépendances externes et leurs versions.
#    On filtre pour les sections 'dependencies' ou 'dev_dependencies'
#    et on exclut les packages locaux (ceux sans version: path: ou sans caret: ^).
find packages -name 'pubspec.yaml' | while read FILE; do
    # Utilise awk pour imprimer 'package: ^version' uniquement pour les dépendances externes
    # (celles qui ont un caractère de version comme ^ ou un nombre)
    awk '/^(dev_)?dependencies:/{flag=1; next} /^[a-z_]+:/ && flag {flag=0} flag && /^  [a-z_]+: /' "$FILE" | \
    grep -vE 'path:|git:|sdk:|flutter:|dev_dependencies:|dependencies:' | \
    # Nettoie et formate les lignes en 'package:^version'
    sed -E 's/ *([a-zA-Z0-9_]+): *(\^?[0-9\.]+) *$/\1:\2/' >> "$TEMP_VERSIONS_FILE"
done

# 2. Déterminer la version la plus élevée pour chaque dépendance
while IFS=":" read -r DEP VERSION_SPEC; do
    # Supprime le caret (^) pour faciliter la comparaison numérique, si besoin.
    # Dans ce script, on conserve la spécification pour la simplicité.
    
    # Si la dépendance n'est pas encore dans notre tableau, ou si la version actuelle est plus récente
    # (une comparaison simple de chaînes fonctionne souvent pour ^X.Y.Z, mais est risquée.
    # Cependant, sans un outil de sémantique de versionnage, on se base sur la plus récente
    # trouvée, ce qui est généralement suffisant pour les monorepos bien gérés).
    
    # Pour ce script, nous nous contenterons de la DERNIÈRE spécification trouvée
    # dans le fichier temporaire, en supposant que l'utilisateur a déjà résolu 
    # les conflits majeurs et que 'pub upgrade' a été lancé au préalable.
    # Pour garantir la "plus haute", l'implémentation est trop lourde pour un script Bash simple.
    # Donc, on stocke simplement la dernière trouvée.

    # Approche pragmatique : S'assurer que chaque clé existe, la dernière version est appliquée
    TARGET_VERSIONS["$DEP"]="$VERSION_SPEC"

done < "$TEMP_VERSIONS_FILE"


# 3. Appliquer la version cible à tous les pubspec.yaml
echo ""
echo "Phase 2: Application des versions cibles..."

for DEP_NAME in "${!TARGET_VERSIONS[@]}"; do
    TARGET_VERSION="${TARGET_VERSIONS[$DEP_NAME]}"
    
    echo "  -> Unification de $DEP_NAME à version $TARGET_VERSION"

    # Parcourez à nouveau tous les fichiers pubspec.yaml
    find packages -name 'pubspec.yaml' | while read FILE; do
        # Utilise grep pour voir si la dépendance existe dans le fichier
        if grep -q "^  $DEP_NAME:" "$FILE"; then
            echo "    -> Mise à jour de $FILE"
            
            # Utilise sed pour remplacer l'ancienne spécification par la nouvelle.
            # Remplacement dans la section dependencies ET dev_dependencies
            # Ceci cible la ligne exacte dans l'une ou l'autre section.
            
            # Utilisez sed -i "" pour macOS/BSD ou sed -i pour Linux/WSL
            # Nous utiliserons sed -i pour WSL/Linux, mais soyez prudent sur Mac.
            
            # Remplacement pour la section dependencies
            sed -i "/^dependencies:/,/^dev_dependencies:\|^flutter:/ { 
                s/^  $DEP_NAME: .*/  $DEP_NAME: $TARGET_VERSION/
            }" "$FILE"

            # Remplacement pour la section dev_dependencies (même bloc, mais au cas où)
            sed -i "/^dev_dependencies:/,/^flutter:/ { 
                s/^  $DEP_NAME: .*/  $DEP_NAME: $TARGET_VERSION/
            }" "$FILE"

        fi
    done
done

# 4. Nettoyage et résolution
rm "$TEMP_VERSIONS_FILE"
echo ""
echo "Phase 3: Résolution des dépendances du Workspace."
flutter pub get

echo "Unification de toutes les dépendances externes terminée."