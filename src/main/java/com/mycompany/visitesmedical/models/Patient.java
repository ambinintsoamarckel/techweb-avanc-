package com.mycompany.visitesmedical.models;

import jakarta.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "patient")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long codepat;

    private String nom;
    private String prenom;
    private String sexe;
    private String adresse;

    // Constructeur par défaut (obligatoire pour JPA)
    public Patient() {}

    // Constructeur avec paramètres
    public Patient(String nom, String prenom, String sexe, String adresse) {
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.adresse = adresse;
    }

    // Getters et Setters
    public Long getCodepat() { return codepat; }
    public void setCodepat(Long codepat) { this.codepat = codepat; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    // Méthode pour obtenir le nom complet du patient
    public String getFullName() {
        return prenom + " " + nom;
    }

    // Vérification si les champs obligatoires sont bien remplis
    public boolean isValid() {
        return nom != null && !nom.isEmpty() &&
               prenom != null && !prenom.isEmpty() &&
               sexe != null && !sexe.isEmpty();
    }

    // Affichage des informations du patient
    @Override
    public String toString() {
        return "Patient{" +
                "codepat=" + codepat +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", sexe='" + sexe + '\'' +
                ", adresse='" + adresse + '\'' +
                '}';
    }

    // Comparaison d'objets Patient
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Patient patient = (Patient) o;
        return Objects.equals(codepat, patient.codepat);
    }

    @Override
    public int hashCode() {
        return Objects.hash(codepat);
    }
}
