# Common mistakes at production

---

## About Me

- SoftServe - Golang evangelist
- Twitter: @arbrix
- Github: arbrix
- GolangUA!: https://golang.org.ua

---

### It is not the problem to write nice code until it goes into production

---

## Production defenition

- Public use |
- Strict access or no any ... |
- An application may be run in a multi-instance mode |
- It is hard to reproduce client bugs |
- You even can't imagine in what way your service may be used 😈 |
- Your variants ... |

---

## How we should prepare our solution?

---

## Static analyzation of code

- unhandled errors |
- deadlocks |
- leak goroutines |
- don't panic |
- ... |

---

## Fuzzy testing, tests coverage

- testing the what, not the how (Mat Ryer) |
- failed test should lead to the problem |
- cover your API with tests |
- test your API in concurrent mode |

---

## Profiling

- it is too late to start profiling when you had faced with a problem in production |
- check for memory leaks |
- check for goroutines leaks |
- check performance of heaviest parts by benchmarks |

---

## Logging

- Log only actionable information, which will be read by a human or a machine (Peter Bourgon) |
- add necessary context to your logs, write all in one operation |
- use structured logs |

---

## Metrics

- USE: utilization, saturation, and error count (rate) |
- RED: request count (rate), error count (rate), and duration |
- application metrics: memory, goroutines, GC pauses |

---

## Mistakes with code base

- copy-pasted code from examples without full understanding |
- used PoC code as a final solution |
- used clever and complex tricks |
- low decomposition level |
- well documented specification and decisions  |

---

## Package Organization - Applications

- has a huge impact on the testability and functionality of your system |
- is easy to understand, easy to refactor, and easy for someone else to maintain |

---
### Package Organization - Application

- Domain Types are types that model your business functionality and objects |
- Services are packages that operate on or with the domain types |

---

### Package Organization - Application

- domain interfaces should be in separate packages, organized by dependency |
  - External data sources |
  - Transport logic (http, RPC) |

---

### Package Organization - Applications

Why one package per dependency?

- Simple testing |
- Easy substitution/replacement |
- No circular dependencies |

---

## Links

- [Code Like the Go Team by Ashley McNamara at GopherCon Russia 2018](https://talks.bjk.fyi/bketelsen/gcru18-best#/)
- [The Art of Testing by Mat Ryer at dotGo 2017](https://www.dotconferences.com/2017/11/mat-ryer-the-art-of-testing)
- [Successful Go Program Design, 6 Years On by Peter Bourgon at QCon Jul 13, 2016](https://www.infoq.com/presentations/go-patterns)
- [Site Reliability Engineering by Googlers](https://landing.google.com/sre/book.html)

---

### Questions?

<br>

@fa[twitter gp-contact](@arbrix)

---?image=assets/image/gitpitch-audience.jpg&opacity=100

@title[Thank you!]

### Thank your!