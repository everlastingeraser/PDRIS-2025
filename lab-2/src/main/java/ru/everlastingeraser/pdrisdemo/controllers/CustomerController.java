package ru.everlastingeraser.pdrisdemo.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ru.everlastingeraser.pdrisdemo.entities.Customer;
import ru.everlastingeraser.pdrisdemo.repositories.CustomerRepository;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1")
public class CustomerController {

    private final CustomerRepository repository;

    @GetMapping("/home")
    public String home() {
        return "Welcome to home page. Application is running";
    }

    @PostMapping("/customers")
    public Customer createCustomer(@RequestBody Customer customer) {
        if (customer.getId() == null) {
            customer.setId(java.util.UUID.randomUUID());
        }
        return repository.save(customer);
    }
}
