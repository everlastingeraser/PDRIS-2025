package ru.everlastingeraser.pdrisdemo.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "customers")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Customer {
    @Id
    private UUID id = UUID.randomUUID();
    private String email;
    private String firstName;
    private String lastName;
}