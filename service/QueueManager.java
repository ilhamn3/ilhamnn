package com.opp.project.service;

import com.opp.project.util.RequestFileUtil;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

abstract class Queue {
    protected int maxSize;
    protected String[] queue;
    protected int front;
    protected int rear;
    protected int currentSize;

    public Queue(int maxSize) {
        this.maxSize = maxSize;
        this.queue = new String[maxSize];
        this.front = 0;
        this.rear = -1;
        this.currentSize = 0;
    }

    public abstract boolean isFull();
    public abstract boolean isEmpty();
    public abstract void enqueue(String request);
    public abstract String dequeue();
    public abstract void updateRequest(int requestId, String newStatus);
}

class CircularQueue extends Queue {
    public CircularQueue(int maxSize) {
        super(maxSize);
    }

    @Override
    public boolean isFull() {
        return currentSize == maxSize;
    }

    @Override
    public boolean isEmpty() {
        return currentSize == 0;
    }

    @Override
    public void enqueue(String request) {
        if (isFull()) {
            dequeue();
        } else {
            currentSize++;
        }
        rear = (rear + 1) % maxSize;
        queue[rear] = request;
    }

    @Override
    public String dequeue() {
        if (isEmpty()) {
            return null;
        }
        String request = queue[front];
        queue[front] = null;
        front = (front + 1) % maxSize;
        currentSize--;
        return request;
    }

    @Override
    public void updateRequest(int requestId, String newStatus) {
        int index = front;
        int count = currentSize;
        while (count > 0) {
            if (queue[index] != null) {
                String[] requestData = queue[index].split(",");
                if (Integer.parseInt(requestData[0]) == requestId) {
                    requestData[4] = newStatus;
                    queue[index] = String.join(",", requestData);
                    return;
                }
                count--;
            }
            index = (index + 1) % maxSize;
        }
    }
}

public class QueueManager {
    private static final int MAX_QUEUE_SIZE = 100;
    private static CircularQueue requestQueue;

    static {
        requestQueue = new CircularQueue(MAX_QUEUE_SIZE);
        loadQueueFromFile();
    }

    public static List<String[]> getQueueState() {
        List<String[]> requests = new ArrayList<>();
        int index = requestQueue.front;
        int count = requestQueue.currentSize;
        while (count > 0) {
            if (requestQueue.queue[index] != null) {
                requests.add(requestQueue.queue[index].split(","));
                count--;
            }
            index = (index + 1) % requestQueue.maxSize;
        }
        return requests;
    }

    private static void loadQueueFromFile() {
        List<String[]> requests = RequestFileUtil.readRequests();
        for (String[] request : requests) {
            String requestData = String.join(",", request);
            requestQueue.enqueue(requestData);
        }
    }

    public static void saveRequest(String studentId, String courseId, String status) {
        int requestId = generateRequestId();
        String timestamp = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String requestData = String.format("%d,%s,%s,%s,%s", requestId, studentId, courseId, timestamp, status);
        requestQueue.enqueue(requestData);
        syncToFile();
    }

    public static void approveFrontRequest() {
        String frontRequest = requestQueue.dequeue();
        if (frontRequest != null) {
            String[] requestData = frontRequest.split(",");
            String enrollmentData = String.format("%s,%s%n", requestData[1], requestData[2]);
            RequestFileUtil.saveEnrollment(enrollmentData);
            syncToFile();
        }
    }

    public static void rejectFrontRequest() {
        if (!requestQueue.isEmpty()) {
            try {
                String[] requestData = requestQueue.queue[requestQueue.front].split(",");
                int requestId = Integer.parseInt(requestData[0]);
                requestQueue.updateRequest(requestId, "rejected");
                syncToFile();
                requestQueue.dequeue();
                syncToFile();
            } catch (Exception e) {
                // Error handling without logging
            }
        }
    }

    public static void deleteFrontRequest() {
        requestQueue.dequeue();
        syncToFile();
    }

    private static int generateRequestId() {
        List<String[]> requests = RequestFileUtil.readRequests();
        int maxId = 0;
        for (String[] request : requests) {
            try {
                int id = Integer.parseInt(request[0]);
                maxId = Math.max(maxId, id);
            } catch (NumberFormatException e) {
                // Error handling without logging
            }
        }
        return maxId + 1;
    }

    private static void syncToFile() {
        List<String[]> requests = new ArrayList<>();
        int index = requestQueue.front;
        int count = requestQueue.currentSize;
        while (count > 0) {
            if (requestQueue.queue[index] != null) {
                requests.add(requestQueue.queue[index].split(","));
                count--;
            }
            index = (index + 1) % requestQueue.maxSize;
        }
        try {
            RequestFileUtil.writeRequests(requests);
        } catch (Exception e) {
            // Error handling without logging
        }
    }
}