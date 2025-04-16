# 🚀 AWS SNS → SQS → Lambda Архітектура через Terraform

Цей проєкт демонструє як реалізувати інфраструктуру, де:
- **SNS Topic** доступний на рівні AWS Organization;
- **SQS Queue** підписана на цей топік;
- **Lambda Function** обробляє повідомлення з черги.

---

## 🗺️ Архітектура

```mermaid
graph TD
  subgraph AWS Organization
    SNS["🟣 SNS Topic"]
  end

  SNS --> SQS["📨 SQS Queue"]
  SQS --> Lambda["🟢 Lambda Function"]

  SNS -->|Publish (Org-level)| SQS
  SQS -->|Trigger| Lambda
```

---

## 🧱 Компоненти

### 🔹 SNS Topic з доступом на рівні організації

```hcl
resource "aws_sns_topic" "my_topic" {
  name = "my-org-topic"
}

data "aws_iam_policy_document" "sns_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["SNS:Publish"]
    resources = [aws_sns_topic.my_topic.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["o-xxxxxxxxxx"] # Заміни на свій Org ID
    }
  }
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn    = aws_sns_topic.my_topic.arn
  policy = data.aws_iam_policy_document.sns_policy.json
}
```

---

### 🔹 SQS Queue + Policy для SNS

```hcl
resource "aws_sqs_queue" "my_queue" {
  name = "sns-to-lambda-queue"
}

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.my_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.my_topic.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.my_queue.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}
```

---

### 🔗 Підписка SQS на SNS

```hcl
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn
  raw_message_delivery = true
}
```

---

### 🧠 Lambda + IAM роль

```hcl
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_sqs_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}
```

---

### ⚙️ Lambda Function + Event Source Mapping

```hcl
resource "aws_lambda_function" "my_lambda" {
  function_name = "handle-sqs-msg"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_lambda_event_source_mapping" "lambda_sqs_trigger" {
  event_source_arn = aws_sqs_queue.my_queue.arn
  function_name    = aws_lambda_function.my_lambda.arn
  batch_size       = 10
}
```

---

## 💻 Lambda код (Node.js приклад)

**lambda/index.js**
```js
exports.handler = async (event) => {
  for (const record of event.Records) {
    console.log("Message received:", record.body);
  }

  return {
    statusCode: 200,
    body: JSON.stringify("Processed!"),
  };
};
```

---

## 🚀 Деплой

```bash
terraform init
terraform apply
```

---

## 🧪 Тестування SNS

```bash
aws sns publish   --topic-arn arn:aws:sns:region:account-id:my-org-topic   --message "Hello from Org SNS"   --region your-region
```

---

## 📸 Діаграма

Для візуального представлення можна використати [diagrams.net](https://draw.io) або [Cloudcraft](https://cloudcraft.co), або вбудовану Mermaid-діаграму (вище).

---

## 📦 Структура проєкту

```
.
├── main.tf
├── variables.tf
├── lambda/
│   └── index.js
└── README.md
```

---

Звертайся, якщо потрібно адаптувати цей проєкт під конкретний use-case або хостити в GitHub! 🙌