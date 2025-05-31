package com.opp.project.service;

import com.opp.project.model.Student;

import java.util.List;

public class SortManager {
    // Insertion Sort to sort students by registration time
    public static void insertionSortByRegistrationTime(List<Student> students) {
        for (int i = 1; i < students.size(); i++) {
            Student key = students.get(i);
            int j = i - 1;

            // Compare registration times and shift elements
            while (j >= 0 && students.get(j).getRegistrationTime().isAfter(key.getRegistrationTime())) {
                students.set(j + 1, students.get(j));
                j--;
            }
            students.set(j + 1, key);
        }
    }
}