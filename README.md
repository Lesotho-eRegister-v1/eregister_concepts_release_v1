# eregister_concepts_release_v1

!!! warning
    * Just a temporary guide
----------------------------------------------------------------------------------

1. ssh into your server with `ssh openmrs@server_ip` and then enter the server the password when prompted
2. Make sure you're in the home folder with `cd ~`
3. clone the concepts folder by running `sudo git clone https://github.com/Lesotho-eRegister-v1/eregister_concepts_release_v1.git`
4. Get into the Concepts folder with `cd eregister_concepts_release_v1.sql`
5. Copy the concepts file into the container with `docker cp omrs_concept_dictionary_v1.sql bahmni-standard-openmrsdb-1:/`
5. Get into your container cli with `docker exec -it bahmni-standard-openmrsdb-1 bash`
6. CD to the root folder with `cd /`
7. Get into your MySQL server by running `mysql -u root -p`
8. Choose your db `use openmrs`
9. Import the latest concepts with `source eregister_concepts_release_v1.sql`