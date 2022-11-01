Then we show the use of terraform fmt, which can autoformat any file ending in .tf.

Finally, we cover how we can have terraform plan output the results (the plan), which makes the apply command run faster (it does not need to re-calculate what it will apply).

```
terraform plan -out output.hcl
terraform apply output.hcl
```