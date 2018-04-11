# Concurrency

Shows simple examples of increasing concurrency levels with Elixir.

## Getting Started

1. Install a Docker client such as  _Docker for Mac_.
2. `git clone git@github.com:AbleTech/concurrency.git`
3. `cd concurrency`
4. `cp .container-sample.env .container.env`
5. `cp .envrc-sample .envrc`
6. `docker-compose up -d`
7. `docker-compose exec elixir bash`
8. `psql -h postgres -U postgres -d concurrency < priv/addresses.sql`

## Examples

You need to have completed the _Getting Started_ steps, and should have a _bash_ 
shell prompt within the Elixir container. Each of these examples process the 100,000 address records stored within the `addresses` table.

**SequentialProcessor**

Queries the `addresses` table, loads all the records, and then processes each line sequentially.

Command: `time mix run -e Concurrency.SequentialProcessor.run`

Time: about 3 mins

**SequentialStreamProcessor**

Queries the `addresses` table, streams the records, and processes each line sequentially.

Command: `time mix run -e Concurrency.SequentialStreamProcessor.run`

Time: about 2 mins

**ConcurrentProcessor**

Queries the `addresses` table, loads all the records, and then processes each line concurrently.

Command: `time mix run -e Concurrency.ConcurrentProcessor.run`

Time: about 1 mins

**SequentialFunctions**

Queries the `addresses` table, streams the records and looks for longest/shortest/etc addresses. 
Performs each of the searches sequentially. 

Command: `time mix run -e Concurrency.Functions.SequentialFunctions.run`

Time: about 5 secs

**ConcurrentFunctions**
Queries the `addresses` table, streams the records and looks for longest/shortest/etc addresses. 
Performs each of the searches concurrently. 

Command: `time mix run -e Concurrency.Functions.ConcurrentFunction.run`

Time: about 3 secs

## Timing

Use the `time` command to compare execution times. For example: 

`time mix run -e Concurrency.Functions.ConcurrentFunction.run` 

```
real	0m2.898s
user	0m4.050s
sys	0m0.860s
```

This example shows that the execution time was approx 2.9 seconds, but the amount of consumed CPU time was closer to 4 seconds. 
