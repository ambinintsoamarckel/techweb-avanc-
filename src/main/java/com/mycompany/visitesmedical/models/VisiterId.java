package com.mycompany.visitesmedical.models;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Représente la clé primaire composite pour la table "visiter"
 */
public class VisiterId implements Serializable {
    private Long medecin;
    private Long patient;
    private LocalDateTime dateTime; // Changement ici

    // Constructeurs
    public VisiterId() {}

    public VisiterId(Long medecin, Long patient, LocalDateTime dateTime) {
        this.medecin = medecin;
        this.patient = patient;
        this.dateTime = dateTime;
    }

    // Getters et Setters (optionnels selon besoin)
    public Long getMedecin() { return medecin; }
    public void setMedecin(Long medecin) { this.medecin = medecin; }

    public Long getPatient() { return patient; }
    public void setPatient(Long patient) { this.patient = patient; }

    public LocalDateTime getDateTime() { return dateTime; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime; }

    // HashCode et Equals pour garantir l'unicité
    @Override
    public int hashCode() {
        return Objects.hash(medecin, patient, dateTime);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        VisiterId visiterId = (VisiterId) obj;
        return Objects.equals(medecin, visiterId.medecin) &&
               Objects.equals(patient, visiterId.patient) &&
               Objects.equals(dateTime, visiterId.dateTime);
    }
}
