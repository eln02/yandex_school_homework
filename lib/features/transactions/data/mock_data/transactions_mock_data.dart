abstract class TransactionsMockData {
  static final transactionResponse = {
    "id": 38,
    "account": {"id": 1, "name": "", "balance": "5500.79", "currency": "RUB"},
    "category": {"id": 1, "name": "Зарплата", "emoji": "💰", "isIncome": true},
    "amount": "500.00",
    "transactionDate": "2025-06-13T13:45:48.282Z",
    "comment": "Зарплата за месяц",
    "createdAt": "2025-06-13T13:46:12.946303Z",
    "updatedAt": "2025-06-13T13:46:12.946303Z",
  };

  static final transaction = {
    "id": 42,
    "accountId": 1,
    "categoryId": 1,
    "amount": "5000.00",
    "transactionDate": "2025-06-13T13:45:48.282Z",
    "comment": "Зарплата за месяц",
    "createdAt": "2025-06-13T15:15:21.868672Z",
    "updatedAt": "2025-06-13T15:15:21.868672Z",
  };
}
