#!/bin/bash

#update_line_value_2() {
#  local line="$1"
#  local new_value="$2"
#  local file="$3"
#
#  # Recherche de la ligne dans le fichier
#  if grep -qF "$line" "$file"; then
#    # Si la ligne existe, la mettre à jour avec la nouvelle valeur
#     sed -i "s/$line.*/$line $new_value/" "$file"
#  else
#    # Sinon, ajouter la ligne au fichier
#    echo "$line $new_value" | sudo tee -a "$file"
#  fi
#}
trim() {
  local var="$1"
  var="${var#"${var%%[![:space:]]*}"}"   # Supprime les espaces au début
  var="${var%"${var##*[![:space:]]}"}"   # Supprime les espaces à la fin
  echo "$var"
}
#update_line_value() {
#  local line="$1"
#  local new_value="$2"
#  local file="$3"
#  local separator="$4"
#  #echo "|$separator|"
#  # Recherche de la ligne dans le fichier
#  if grep -qF "$line" "$file"; then
#    # Si la ligne existe, mettre à jour avec la nouvelle valeur
#    if [[ $(uname) == "Darwin" ]]; then
#      # Sur macOS
#      echo ""
#      #sed -i '' -e "s/${line}.*/${line}$separator${new_value}/" "$file"
#    else
#      # Sur Linux
#      sed -i "s/${line}.*/${line}$separator${new_value}/" "$file"
#    fi
#  else
#    # Sinon, ajouter la ligne au fichier
#    echo "$line $new_value" | sudo tee -a "$file"
#  fi
#}
update_line_value() {
  local line="$1"
  local new_value="$2"
  local file="$3"
  local separator="$4"

  # Use a pipe as the sed delimiter
  local sed_delimiter="|"

  # Recherche de la ligne dans le fichier
  if grep -qF "$line" "$file"; then
    # Si la ligne existe, mettre à jour avec la nouvelle valeur
    if [[ $(uname) == "Darwin" ]]; then
      # Sur macOS
      sed -i '' -e "s${sed_delimiter}${line}.*${sed_delimiter}${line}${separator}${new_value}${sed_delimiter}" "$file"
    else
      # Sur Linux
      sed -i "s${sed_delimiter}${line}.*${sed_delimiter}${line}${separator}${new_value}${sed_delimiter}" "$file"
    fi
  else
    # Sinon, ajouter la ligne au fichier
    echo "$line${separator}$new_value" | sudo tee -a "$file"
  fi
}

#!/bin/bash

function_bash() {
    # Vérifier si le fichier est spécifié en argument
    if [ $# -eq 0 ]; then
        echo "Usage: function_bash <nom_fichier> <motif>"
        return 1
    fi

    local fichier="$1"
    local motif="$2"
    local separator="$3"
    if [ -z "$separator" ]; then
        separator=":"  # Set to space if not defined
    fi
    # Vérifier si le fichier existe
    if [ ! -f "$fichier" ]; then
        echo "Le fichier $fichier n'existe pas."
        return 1
    fi

    # Rechercher la ligne correspondant au motif
    ligne=$(grep "$motif" "$fichier")

    # Extraire la valeur après le motif
    if [ -n "$ligne" ]; then
        valeur=$(echo "$ligne" | awk -F "$separator" '{print $2}')
        valeur=$(trim "$valeur")
        echo  "$valeur"
    else
        echo "Le motif $motif n'a pas été trouvé dans le fichier."
    fi
}

# Exemple d'utilisation
#resultat=$(function_bash "credential.txt" "mot-de-passe-keystore-MTLS")
#resultat=$(function_bash "credential.txt" "mot-de-passe-keystore-MTLS")
#echo "La valeur est : $resultat"
#
#update_line_value "PASSWORD=" "$(function_bash "credential.txt" "mot-de-passe-keystore-MTLS" ":")" "config.txt" ""
# shellcheck disable=SC2016
#line_new='$TYPE_CERTIF: $GENERATED_PASSWORD_TRUSTSTORE" >> $REP_KEYSTORE/credentials.txt'
#update_line_value "echo mot-de-passe-truststore-" "$line_new" "generer-keystore.txt" ""