#!/bin/bash

# Skrypt instalacyjny dla Ansible na Fedorze

# Sprawdzenie, czy skrypt jest uruchomiony z uprawnieniami roota
if [ "$EUID" -ne 0 ]
  then echo "Ten skrypt wymaga uprawnień roota. Uruchom go z sudo."
  exit
fi

# Instalacja Ansible
echo "Instalacja Ansible..."
dnf install ansible -y

# Sprawdzenie wersji Ansible
echo "Zainstalowana wersja Ansible:"
ansible --version

# Tworzenie katalogu projektu
echo "Tworzenie katalogu projektu..."
mkdir -p ~/ansible_projekt
cd ~/ansible_projekt

# Tworzenie pliku inventory
echo "Tworzenie pliku inventory..."
echo "localhost ansible_connection=local" > inventory

# Tworzenie pliku ansible.cfg
echo "Tworzenie pliku konfiguracyjnego ansible.cfg..."
echo "[defaults]
inventory = inventory" > ansible.cfg

# Tworzenie playbooka
echo "Tworzenie playbooka test_strony.yml..."
cat << EOF > test_strony.yml
---
- name: Test strony i serwera
  hosts: localhost
  tasks:
    - name: Sprawdź działanie serwera HTTP
      uri:
        url: http://example.com
        return_content: yes
      register: http_response

    - name: Wyświetl status odpowiedzi
      debug:
        msg: "Status odpowiedzi: {{ http_response.status }}"

    - name: Sprawdź obecność określonego ciągu w treści strony
      assert:
        that:
          - "'Example Domain' in http_response.content"
        fail_msg: "Nie znaleziono oczekiwanego ciągu w treści strony"
        success_msg: "Znaleziono oczekiwany ciąg w treści strony"
EOF

echo "Instalacja i konfiguracja zakończona."
echo "Możesz teraz uruchomić playbook komendą:"
echo "ansible-playbook ~/ansible_projekt/test_strony.yml"