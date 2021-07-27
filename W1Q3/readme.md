# Solution for W1Q3 and W1Q4

## Setup

```
$ flow emulator --verbose
$ flow project deploy
```

## Create secondary account

```
$ flow accounts create --key f0c1b0e08190780e5c75b48ded16a4efad8a27bc3addeceea48e7c0a03b6374800c540b60c6f5f0ee2a498cbc6a2eb224c2559592217df4a24a6e92f38bc1a5f
```

Copy the generated account address without 0x, eg. `f3fcd2c1a78f5eee`

## Print pictures

```
$ flow transactions send ./print.transaction.cdc --arg String:"*   * * *   *   * * *   *"
$ flow transactions send ./print.transaction.cdc --arg String:"*   * * *   *   * * *   *"
$ flow transactions send ./print.transaction.cdc --arg String:"*************************"
# Second account
$ flow transactions send ./print.transaction.cdc --arg String:"* * * * * * * * * * * * *" --signer secondary-account
$ flow transactions send ./print.transaction.cdc --arg String:" * * * * * * * * * * * * " --signer secondary-account
```

The first time you execute a transaction with a pixel pattern you should see

```
DEBU[xxxx] LOG [xxxxxx] "Picture printed!"
DEBU[xxxx] LOG [xxxxxx] "Picture saved!"
```

and any time later:

```
DEBU[xxxx] LOG [xxxxxx] "Picture with *   * * *   *   * * *   * already exists!"
```

You can draw different pixel patterns, eg.

```
$ flow transactions send ./print.transaction.cdc --arg String:"*************************"
```

---

```
$ flow scripts execute ./getCollections.script.cdc --arg Address:f8d6e0586b0a20c7
$ flow scripts execute ./getCollections.script.cdc --arg Address:01cf0e2f2f715450
```

Should display all the different pictures you've drawn so far
