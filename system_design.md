# System Design Memorization Roadmap

No fluff -- just the core designs you need to know from memory.
Order follows the [NeetCode System Design](https://neetcode.io/courses/system-design-for-beginners/0) and [System Design Interview](https://neetcode.io/courses/system-design-interview/0) roadmaps.

## How to use this sheet

Each step is one system design pattern or building block. For every step:
1. Read the explanation until the tradeoffs click.
2. Close the file and redraw the architecture from memory.
3. Walk through the example problems and design them without looking back.

Steps are ordered so each tier builds on the last. Do not skip ahead.

---

## TIER 1: FOUNDATIONS (Building Blocks)

Core infrastructure concepts that every design uses.

---

### Step 1. Client-Server Model
> **What:** A client sends requests; a server processes them and returns responses.
> **Why:** Separates concerns -- clients handle UI, servers handle business logic and data. Enables many clients to share one backend.
> **When:** Literally every system. This is the base mental model.

```
KEY CONCEPTS:
- Client: browser, mobile app, or another service making requests
- Server: process listening on a port, handling requests
- Protocol: HTTP/HTTPS (request-response), WebSocket (bidirectional persistent)
- DNS: translates domain names (google.com) to IP addresses

RECOGNIZE IT: every design starts here. Draw the client and the server first,
then figure out what sits between them (load balancers, CDNs, etc.).
```

**Practice:** Design a basic web app, Design a URL shortener (start from the client-server interaction)

---

### Step 2. Databases (SQL vs NoSQL)
> **What:** Persistent storage for your application data.
> **Why:** Different data shapes and access patterns demand different storage engines. Choosing wrong = performance nightmare or data integrity bugs.
> **When:** Every system needs a database. The question is WHICH type.

```
SQL (Relational) -- PostgreSQL, MySQL
- WHY: ACID guarantees (Atomicity, Consistency, Isolation, Durability).
  Strong consistency. Structured data with relationships (foreign keys, joins).
- WHEN: transactions matter (payments, inventory), data has clear relationships,
  you need complex queries (JOINs, aggregations).
- RECOGNIZE IT: "users have orders have items" = relational.

NoSQL (Non-Relational) -- MongoDB, DynamoDB, Cassandra
- WHY: Flexible schema, horizontal scaling, optimized for specific access patterns.
- WHEN: massive scale, schema changes frequently, data is naturally document-shaped
  or key-value, you do not need JOINs.
- TYPES:
  - Document store (MongoDB): nested JSON-like objects, flexible schema
  - Key-value store (Redis, DynamoDB): fast lookups by key, simple data model
  - Wide-column store (Cassandra): high write throughput, time-series data
  - Graph database (Neo4j): relationships ARE the data (social networks)

INDEXING (comes up in deep dives):
- B-tree index: balanced tree on disk. Good for reads and range queries.
  Default in PostgreSQL/MySQL. O(log n) lookups.
- LSM-tree (Log-Structured Merge-tree): append to in-memory table, flush to
  sorted files on disk. Good for write-heavy workloads.
  Used by Cassandra, RocksDB, LevelDB. (See Step 23: Key-Value Store.)
- Rule of thumb: read-heavy -> B-tree (SQL). Write-heavy -> LSM-tree (NoSQL).

DECISION FRAMEWORK:
- Need ACID transactions? -> SQL
- Need flexible schema + horizontal scale? -> NoSQL (document)
- Need blazing fast lookups by key? -> NoSQL (key-value)
- Need to model complex relationships with traversals? -> Graph DB
```

**Practice:** Design Twitter (SQL for users, NoSQL for tweets?), Design an E-Commerce platform (SQL for orders), Design a Social Network (graph DB for connections?)

---

### Step 3. Scaling: Vertical vs Horizontal
> **What:** Vertical = bigger machine. Horizontal = more machines.
> **Why:** Single machines have limits. Horizontal scaling is how you serve millions of users.
> **When:** Whenever the interviewer says "scale to X million users."

```
VERTICAL SCALING (Scale Up)
- WHY: Simple. No code changes. Just get a bigger server (more CPU, RAM, disk).
- LIMIT: There is a ceiling -- you cannot buy an infinitely large machine.
- WHEN: Early stage, small-to-medium load, databases (scaling DBs horizontally is hard).

HORIZONTAL SCALING (Scale Out)
- WHY: No ceiling in theory. Add more servers as traffic grows.
- REQUIRES: stateless servers (no local session state), load balancer, data replication.
- WHEN: high traffic, need fault tolerance (one server dies, others take over).

KEY INSIGHT: almost every system design answer involves horizontal scaling at some
point. The follow-up is always: "how do you distribute traffic?" -> load balancer.
"how do you share data?" -> shared database or cache.
```

**Practice:** Design a system that handles 10M daily active users, Scale a monolithic app to microservices

---

### Step 4. Load Balancing
> **What:** Distributes incoming traffic across multiple servers.
> **Why:** No single server handles all traffic. Load balancers spread the load and provide failover.
> **When:** Any horizontally scaled system (so... basically every design).

```
STRATEGIES:
- Round Robin: requests go to servers in order (1, 2, 3, 1, 2, 3...).
  Simple but ignores server load.
- Weighted Round Robin: heavier servers get more requests.
- Least Connections: send to the server with fewest active connections.
  Better for uneven request durations.
- IP Hash: hash the client IP to pick a server. Same client always hits the
  same server (useful for session affinity, but limits flexibility).

LAYERS:
- L4 (Transport): routes based on IP/port. Fast, no content inspection.
- L7 (Application): routes based on HTTP headers, URL path, cookies.
  Smarter but slightly slower. Can do SSL termination, content-based routing.

TOOLS: Nginx, HAProxy, AWS ALB/NLB, cloud load balancers.

RECOGNIZE IT: any time you draw multiple servers behind a single entry point.
```

**Practice:** Design a web crawler (distribute URLs across workers), Design Netflix (route to nearest CDN/server)

---

### Step 5. Caching
> **What:** Store frequently accessed data in a fast layer (usually in-memory) to avoid hitting the database.
> **Why:** Databases are slow (disk I/O). Caches are fast (RAM). A cache hit is 100-1000x faster than a DB query.
> **When:** Read-heavy workloads, repeated queries for the same data, expensive computations.

```
CACHE STRATEGIES:
- Cache-Aside (Lazy Loading):
  App checks cache first. Cache miss -> read DB -> write to cache -> return.
  WHY: only caches data that is actually requested. Simple.
  RISK: cache miss = slow (extra round trip). Stale data if DB changes.

- Write-Through:
  App writes to cache AND DB simultaneously.
  WHY: cache is always up to date. No stale reads.
  RISK: higher write latency (two writes). May cache data that is never read.

- Write-Behind (Write-Back):
  App writes to cache only. Cache asynchronously flushes to DB.
  WHY: very fast writes.
  RISK: data loss if cache crashes before flushing.

EVICTION POLICIES:
- LRU (Least Recently Used): evict the oldest-accessed item. Most common.
- LFU (Least Frequently Used): evict the least-accessed item.
- TTL (Time To Live): expire after a fixed duration.

TOOLS: Redis, Memcached.

KEY INSIGHT: caching is a tradeoff between speed and data freshness. Always ask
"what happens if the cache serves stale data?" If the answer is "nothing bad" ->
cache aggressively. If "money is lost" -> be careful with TTLs and invalidation.

RECOGNIZE IT: "read-heavy", "low latency", "same data requested repeatedly".
```

**Practice:** Design Twitter Feed (cache timelines), Design a Leaderboard (cache rankings), Design URL Shortener (cache hot URLs)

---

### Step 6. Content Delivery Network (CDN)
> **What:** Geographically distributed network of servers that cache static content close to users.
> **Why:** Serving images/videos/JS from a server in Virginia to a user in Tokyo is slow. CDN edge nodes in Tokyo make it fast.
> **When:** Static assets (images, videos, CSS, JS), global user base, low-latency media delivery.

```
HOW IT WORKS:
1. User requests an image.
2. DNS routes to the nearest CDN edge node.
3. Edge node has it cached? -> return immediately (cache hit).
4. Not cached? -> edge fetches from origin server, caches it, returns to user.

PUSH vs PULL:
- Push CDN: you upload content to the CDN proactively. Good for content you
  know will be popular (e.g., a new movie on Netflix).
- Pull CDN: CDN fetches from origin on first request. Good for long-tail content
  where you do not know what will be popular.

TOOLS: CloudFront (AWS), Cloudflare, Akamai, Fastly.

RECOGNIZE IT: "serve images/videos globally", "low latency for static content",
"users are distributed worldwide".
```

**Practice:** Design Netflix (video CDN), Design Instagram (image CDN), Design a News Website (static page caching)

---

### Step 7. API Design (REST, GraphQL, gRPC)
> **What:** The contract between client and server for how data is requested and returned.
> **Why:** A well-designed API makes the system intuitive, maintainable, and efficient.
> **When:** Every system has APIs. The question is which style.

```
REST (Representational State Transfer)
- WHY: Simple, widely understood, uses standard HTTP methods.
- HOW: Resources identified by URLs. GET /users/123, POST /tweets, DELETE /tweets/456.
- WHEN: public-facing APIs, CRUD operations, web/mobile clients.

GraphQL
- WHY: Client specifies exactly what data it needs. No over-fetching or under-fetching.
- WHEN: complex frontend needs, mobile apps (bandwidth matters), nested relationships.
- TRADEOFF: more complex server, harder to cache (single endpoint).

gRPC (Google Remote Procedure Call)
- WHY: Binary protocol (protobuf). Very fast, supports streaming. Strongly typed.
- WHEN: service-to-service communication (microservices), low-latency internal APIs.
- TRADEOFF: not browser-friendly (needs a proxy), harder to debug than JSON.

KEY INSIGHT: REST for external/public APIs. gRPC for internal microservice calls.
GraphQL when the frontend has complex, varied data needs.
```

**Practice:** Design Twitter API (REST), Design a Dashboard (GraphQL), Design a Chat Service (gRPC streaming)

---

### Step 8. Rate Limiting
> **What:** Restrict how many requests a client can make in a time window.
> **Why:** Prevent abuse, protect backend from overload, ensure fair usage.
> **When:** Any public-facing API, authentication endpoints, expensive operations.

```
ALGORITHMS:
- Token Bucket: bucket fills with tokens at a steady rate. Each request consumes
  a token. Empty bucket = rejected. Allows bursts up to bucket size.
  WHY: smooth rate limiting with burst tolerance. Most common in production.

- Sliding Window Log: store timestamp of each request. Count requests in the
  last N seconds. Precise but memory-heavy.

- Sliding Window Counter: hybrid of fixed window + sliding. Approximates the
  count using weighted average of current and previous window. Memory efficient.

- Fixed Window Counter: count requests per fixed time window (e.g., per minute).
  Simple but allows burst at window boundaries (2x rate).

WHERE TO PLACE IT:
- API Gateway level (centralized, applies to all services)
- Per-service (more granular control)
- Client-side (advisory, not enforceable)

TOOLS: Redis (atomic counters + TTL), Nginx rate limiting, API gateway features.

RECOGNIZE IT: "prevent abuse", "limit to N requests per second", "protect the API".
```

**Practice:** Design a Rate Limiter, Design an API Gateway, Design a DDoS Protection System

---

## TIER 2: DATA AND STORAGE PATTERNS

How to store, retrieve, and manage data at scale.

---

### Step 9. Database Replication
> **What:** Copy data across multiple database servers.
> **Why:** One DB server is a single point of failure AND a throughput bottleneck for reads. Replication solves both.
> **When:** Need high availability (if master dies, a replica takes over) or read scaling.

```
LEADER-FOLLOWER (Master-Slave):
- One leader handles ALL writes. Followers replicate from leader and handle reads.
- WHY: scales reads horizontally. Write consistency is simple (one writer).
- RISK: replication lag means followers may serve slightly stale data.
  Leader failure requires failover (promote a follower).

LEADER-LEADER (Multi-Master):
- Multiple nodes accept writes. They replicate to each other.
- WHY: write availability (no single write bottleneck), geographic distribution.
- RISK: write conflicts (two users update the same row on different masters).
  Conflict resolution is complex. Avoid unless you truly need it.

SYNCHRONOUS vs ASYNCHRONOUS:
- Sync: leader waits for follower to confirm before acknowledging write.
  Strong consistency but slower writes.
- Async: leader acknowledges immediately, follower catches up later.
  Fast writes but risk of data loss if leader crashes before replication.

RECOGNIZE IT: "high availability", "read replicas", "failover", "geographic
distribution of databases".
```

**Practice:** Design a Banking System (strong consistency), Design Twitter (read replicas for timelines)

---

### Step 10. Database Sharding (Partitioning)
> **What:** Split data across multiple database servers, each holding a subset.
> **Why:** One database cannot hold all the data or handle all the queries. Sharding distributes the load.
> **When:** Single database is a bottleneck (too much data, too many queries).

```
HORIZONTAL SHARDING (most common):
- Split ROWS across shards. Each shard has the same schema but different data.
- Shard key: the column used to determine which shard a row goes to.
  e.g., user_id % num_shards, or hash(user_id) % num_shards.

VERTICAL SHARDING:
- Split COLUMNS (tables) across databases. User profiles in DB1, orders in DB2.
- Simpler but limited: eventually each table gets too big and needs horizontal sharding.

CHOOSING A SHARD KEY:
- Good: distributes data evenly, queries mostly hit one shard.
- Bad: hot spots (one shard gets all traffic), cross-shard queries (JOINs across shards).
- Example: shard by user_id for a social media app. User's data is co-located.

CHALLENGES:
- Resharding: adding/removing shards requires redistributing data. Painful.
  Consistent hashing helps minimize data movement.
- Cross-shard queries: JOINs across shards are slow and complex.
- Hotspots: celebrity users overload their shard (mitigate with further splitting).

RECOGNIZE IT: "billions of rows", "single DB is too slow", "partition data".
```

**Practice:** Design a Messenger (shard by conversation_id), Design a Social Network (shard by user_id), Design a URL Shortener (shard by hash)

---

### Step 11. Consistent Hashing
> **What:** A hashing technique that minimizes data redistribution when nodes are added or removed.
> **Why:** Regular hash(key) % N means ALL keys get remapped when N changes. Consistent hashing only moves ~1/N of the keys.
> **When:** Distributed caches, sharding, load balancing across dynamic server pools.

```
HOW IT WORKS:
1. Imagine a hash ring (0 to 2^32).
2. Hash each server to a position on the ring.
3. Hash each key to a position on the ring.
4. A key is assigned to the first server clockwise from its position.

ADDING A SERVER: only keys between the new server and its predecessor move.
REMOVING A SERVER: only its keys move to the next server clockwise.

VIRTUAL NODES: each physical server gets multiple positions on the ring.
WHY: prevents uneven distribution (one server getting a huge arc of the ring).

KEY INSIGHT: consistent hashing is the answer whenever the interviewer asks
"what happens when you add/remove a cache node or shard?"

RECOGNIZE IT: "distributed cache", "add/remove servers dynamically",
"minimize data movement during scaling".
```

**Practice:** Design a Distributed Cache, Design a CDN routing layer, Design a Distributed Key-Value Store

---

### Step 12. Message Queues
> **What:** Asynchronous communication between services via a queue (producer -> queue -> consumer).
> **Why:** Decouples services, absorbs traffic spikes, enables retry logic, and smooths out load.
> **When:** Any async workflow, event-driven architecture, tasks that do not need immediate response.

```
POINT-TO-POINT (Queue):
- One message consumed by exactly one consumer.
- WHY: task distribution (each task processed once).
- Example: order processing, video encoding jobs.

PUBLISH-SUBSCRIBE (Pub/Sub):
- One message delivered to ALL subscribers of a topic.
- WHY: fan-out (one event triggers multiple downstream actions).
- Example: user signs up -> send welcome email AND create analytics event AND update search index.

KEY PROPERTIES:
- Durability: messages persisted to disk (survives crashes).
- Ordering: some queues guarantee FIFO (important for event sourcing).
- At-least-once delivery: consumer may see a message twice. Design consumers
  to be IDEMPOTENT (processing the same message twice has no side effect).
- Dead letter queue (DLQ): messages that fail repeatedly go here for investigation.

TOOLS: Kafka (high throughput, log-based), RabbitMQ (traditional queue),
SQS (AWS managed), Redis Streams.

EVENT SOURCING / CQRS (advanced pattern, comes up in follow-ups):
- Event sourcing: store every state change as an immutable event in a log.
  Rebuild current state by replaying events. Enables audit trail and time travel.
- CQRS (Command Query Responsibility Segregation): separate write model
  (optimized for writes) from read model (optimized for queries).
  Message queue bridges the two -- writes publish events, read models consume
  and update their own denormalized views.
- WHEN: complex domains (order lifecycle, financial transactions), audit
  requirements, or when read and write patterns are very different.

RECOGNIZE IT: "async processing", "decouple services", "handle traffic spikes",
"event-driven", "process in background".
```

**Practice:** Design a Notification System, Design an Order Processing Pipeline, Design a Log Aggregation System

---

### Step 13. Blob Storage & Object Storage
> **What:** Storage optimized for large binary objects (images, videos, files) rather than structured rows.
> **Why:** Databases are bad at storing large blobs. Object storage is cheap, scalable, and built for it.
> **When:** Storing/serving images, videos, documents, backups, logs.

```
HOW IT WORKS:
- Store objects with a unique key (usually a path: "images/user123/avatar.png").
- Flat namespace (not a real filesystem, though "/" makes it look like one).
- Metadata stored alongside the object (content-type, timestamps, custom tags).

KEY PROPERTIES:
- Highly durable (e.g., S3: 99.999999999% durability -- "11 nines").
- Infinitely scalable (no provisioning needed).
- Cheap for storage, pay per GB + per request.
- NOT a database: no queries, no updates to parts of an object. Write whole object or replace it.

INTEGRATION PATTERN:
1. Client requests a pre-signed upload URL from your server.
2. Client uploads directly to blob storage (bypasses your server).
3. Your server stores the object key/URL in the database.
4. For reads: serve via CDN with blob storage as the origin.

TOOLS: S3 (AWS), GCS (Google), Azure Blob Storage.

RECOGNIZE IT: "store images", "upload videos", "file storage", "media service".
```

**Practice:** Design Instagram (photo storage), Design Google Drive (file storage), Design Netflix (video storage)

---

## TIER 3: DISTRIBUTED SYSTEM CONCEPTS

Patterns for reliability, consistency, and coordination at scale.

---

### Step 14. CAP Theorem
> **What:** In a distributed system, you can only guarantee two of three: Consistency, Availability, Partition Tolerance.
> **Why:** Network partitions WILL happen. So the real choice is: during a partition, do you sacrifice consistency or availability?
> **When:** Any time you discuss tradeoffs in distributed databases or services.

```
THE THREE PROPERTIES:
- Consistency (C): every read returns the most recent write. All nodes see the same data.
- Availability (A): every request receives a response (even if it might be stale).
- Partition Tolerance (P): the system continues working despite network failures between nodes.

THE REAL CHOICE (since P is non-negotiable):
- CP (Consistency + Partition Tolerance): during a partition, refuse to serve
  requests rather than serve stale data. Examples: ZooKeeper, HBase, MongoDB (default).
  WHEN: banking, inventory, anything where stale data = money lost.

- AP (Availability + Partition Tolerance): during a partition, serve requests
  even if data might be stale. Examples: Cassandra, DynamoDB, CouchDB.
  WHEN: social media feeds, DNS, anything where "slightly stale" is acceptable.

KEY INSIGHT: CAP is about behavior DURING a partition. When the network is healthy,
you can have all three. The interviewer wants to hear you reason about the tradeoff
for YOUR specific system.

RECOGNIZE IT: "what if a network partition happens?", "consistency vs availability",
"which database for this use case?"
```

**Practice:** Design a Banking System (CP), Design a Social Media Feed (AP), Discuss tradeoffs for any distributed DB choice

---

### Step 15. Consensus & Coordination (Leader Election)
> **What:** Getting distributed nodes to agree on a value or a leader, even if some nodes fail.
> **Why:** Distributed systems need coordination: who is the leader? Is this transaction committed? What is the current config?
> **When:** Leader election, distributed locks, configuration management, service discovery.

```
CONSENSUS ALGORITHMS:
- Raft / Paxos: protocols for getting a majority of nodes to agree on a value.
  Used internally by ZooKeeper, etcd, CockroachDB. You do not implement these
  yourself -- you use tools built on them.

TOOLS:
- ZooKeeper: distributed coordination service. Leader election, distributed locks,
  config management. Reliable but operationally complex.
- etcd: simpler alternative to ZooKeeper (key-value store with consensus). Used by Kubernetes.

LEADER ELECTION PATTERN:
1. Multiple instances of a service start up.
2. They race to acquire a lock in ZooKeeper/etcd.
3. Winner becomes leader, losers become followers.
4. If leader dies, lock is released, followers race again.
WHY: ensures exactly one instance handles writes/coordination at a time.

RECOGNIZE IT: "only one server should process this", "distributed lock", "who is
the master?", "service discovery".
```

**Practice:** Design a Distributed Lock, Design a Config Service, Design a Task Scheduler (leader assigns tasks)

---

### Step 16. Unique ID Generation
> **What:** Generate globally unique IDs across distributed servers without coordination.
> **Why:** Auto-increment IDs require a single database (bottleneck). Distributed systems need IDs that are unique without talking to each other.
> **When:** Any distributed system that creates entities (tweets, orders, messages, URLs).

```
APPROACHES:
- UUID (v4): 128-bit random. Simple, no coordination needed.
  DOWNSIDE: not sortable by time, large (36 chars as string), poor DB index locality.

- Snowflake ID (Twitter): 64-bit ID = timestamp + machine ID + sequence number.
  WHY: sortable by time, compact, no coordination (machine ID is pre-assigned).
  WHEN: need time-ordered IDs at high throughput. This is the go-to answer.

- Database ticket server: centralized auto-increment service.
  WHY: simple, sequential IDs.
  DOWNSIDE: single point of failure (mitigate with multiple ticket servers using different step sizes).

- ULID: like UUID but with a timestamp prefix. Sortable, still random-ish.

SNOWFLAKE BREAKDOWN (64 bits):
  [1 bit unused] [41 bits timestamp] [10 bits machine ID] [12 bits sequence]
  - 41 bits timestamp = ~69 years of milliseconds
  - 10 bits machine ID = 1024 machines
  - 12 bits sequence = 4096 IDs per millisecond per machine

RECOGNIZE IT: "generate unique IDs", "distributed ID generation", "how do you
create tweet IDs / order IDs at scale?"
```

**Practice:** Design a URL Shortener (short unique IDs), Design Twitter (tweet IDs), Design a Distributed Database (row IDs)

---

### Step 17. Heartbeats, Health Checks & Failure Detection
> **What:** Mechanisms for detecting when a server or service has gone down.
> **Why:** In distributed systems, servers die. You need to detect failures quickly to route traffic away and trigger recovery.
> **When:** Any system with multiple servers, microservices, or distributed components.

```
HEARTBEAT:
- Each server periodically sends an "I'm alive" signal to a monitor.
- If no heartbeat received within a timeout -> mark server as dead.
- WHY: simple, widely used.

HEALTH CHECK:
- Monitor actively pings servers (HTTP GET /health).
- Can check deeper health (DB connection, disk space, memory).
- WHY: more informative than heartbeat. Load balancers use this to remove unhealthy backends.

FAILURE DETECTION CHALLENGES:
- Network delays can cause false positives (server is fine but heartbeat was delayed).
- Solution: use multiple checks, exponential backoff, quorum-based detection
  (multiple monitors must agree a server is dead).

RECOGNIZE IT: "what happens when a server dies?", "how does the load balancer
know a server is down?", "failover mechanism".
```

**Practice:** Design a Health Monitoring System, Design any highly available system (this is a sub-component)

---

## TIER 4: CLASSIC SYSTEM DESIGNS

Full end-to-end designs. These combine all the building blocks above.

---

### Step 18. Design a URL Shortener (e.g., TinyURL / Bit.ly)
> **Category:** Core Classic | **Key Concepts:** Hashing, Key-Value Store, Read-Heavy, Caching

```
REQUIREMENTS:
- Shorten a long URL to a short one (e.g., tinyurl.com/abc123).
- Redirect short URL to the original long URL.
- High read volume (many more reads than writes).
- Short URLs should be unique and hard to guess.

HIGH-LEVEL DESIGN:
1. Write path: client sends long URL -> server generates short code -> stores
   mapping (short_code -> long_url) in DB -> returns short URL.
2. Read path: client visits short URL -> server looks up short_code in cache/DB ->
   301/302 redirect to long URL.

KEY DECISIONS:
- ID generation: Base62 encode a Snowflake ID or auto-increment ID.
  6 chars of Base62 = 62^6 = ~56 billion unique URLs. Plenty.
- Storage: key-value store (short_code -> long_url). DynamoDB or Redis + SQL.
- Caching: cache hot URLs in Redis (80/20 rule: 20% of URLs get 80% of traffic).
- Database: simple KV lookup, NoSQL works well. Or a SQL table with short_code as PK.

DEEP DIVES:
- Analytics: log each redirect (async via message queue) for click counts.
- Expiration: TTL on entries, background cleanup job.
- Custom aliases: check for collisions, reserve the alias.
- Rate limiting: prevent abuse (spam URL creation).
```

**Practice (NeetCode):** Design TinyURL, Design PasteBin

---

### Step 19. Design a News Feed / Twitter Timeline
> **Category:** Core Classic | **Key Concepts:** Fan-out, Cache, Pub/Sub, Read/Write Tradeoff

```
REQUIREMENTS:
- Users post tweets / status updates.
- Users see a feed of posts from people they follow.
- Feed is sorted by recency (or relevance).

HIGH-LEVEL DESIGN:
1. Post service: user creates post -> store in Posts DB -> fan out to followers.
2. Feed service: user requests feed -> read their pre-built timeline from cache.

FAN-OUT STRATEGIES:
- Fan-out on Write (Push model):
  When user posts, immediately write to every follower's timeline cache.
  WHY: reads are instant (pre-computed). RISK: celebrities with millions of
  followers cause write storms. Solution: hybrid approach.

- Fan-out on Read (Pull model):
  When user requests feed, fetch latest posts from all followed users and merge.
  WHY: no write amplification. RISK: reads are slow (fetch from many sources).

- Hybrid (Twitter's approach):
  Push for normal users, pull for celebrities. When building your feed,
  merge pre-pushed posts with on-demand celebrity posts.

KEY COMPONENTS:
- Post storage: SQL or NoSQL (post_id, user_id, content, timestamp).
- Timeline cache: Redis sorted set per user (score = timestamp, value = post_id).
- Social graph: who follows whom (adjacency list in DB or graph DB).
- Fan-out service: async workers that push posts to follower timelines via message queue.

DEEP DIVES:
- Ranking: ML model scores posts by relevance instead of pure chronological.
- Media: images/videos stored in blob storage, URLs in posts.
- Notifications: push notifications via a separate notification service.
```

**Practice (NeetCode):** Design Twitter, Design Facebook News Feed, Design Instagram

> **Note:** "Design Instagram" and "Design Facebook" are variations of this same
> core design. Instagram emphasizes photo upload (blob storage + CDN from Step 13)
> plus the feed. Facebook adds the social graph (friend recommendations, privacy
> settings per post). Same fan-out architecture, different deep-dive emphasis.

---

### Step 20. Design a Chat System (e.g., WhatsApp / Messenger)
> **Category:** Core Classic | **Key Concepts:** WebSockets, Message Queue, Presence, Ordering

```
REQUIREMENTS:
- 1:1 and group messaging.
- Real-time delivery (low latency).
- Offline message storage (deliver when user comes online).
- Read receipts, online/offline status.

HIGH-LEVEL DESIGN:
1. Client connects via WebSocket to a chat server (persistent connection).
2. Sending: client sends message -> chat server -> message queue -> recipient's chat server -> recipient.
3. Offline: if recipient is offline, message stored in DB. Delivered on reconnection.

KEY COMPONENTS:
- WebSocket servers: maintain persistent connections with clients. Stateful
  (each server knows which users are connected to it).
- Connection registry: maps user_id -> which WebSocket server they are on.
  Stored in Redis for fast lookup.
- Message queue: Kafka or RabbitMQ. Decouples senders from receivers.
  Ensures message delivery even if recipient's server is temporarily down.
- Message storage: Cassandra or similar (optimized for write-heavy, time-series).
  Partition by conversation_id for co-location.
- Presence service: tracks online/offline status via heartbeats.

KEY DECISIONS:
- Message ordering: use server-side timestamps or logical clocks.
  Within a conversation, messages must appear in consistent order for all participants.
- Group chat: message sent to a group -> fan out to all members.
  Small groups: push to all. Large groups (1000+): consider pull model.
- End-to-end encryption: keys exchanged between clients, server cannot read messages.
- Media messages: upload to blob storage, send URL in message.
```

**Practice (NeetCode):** Design WhatsApp, Design Facebook Messenger, Design Slack, Design Discord

---

### Step 21. Design a Notification System
> **Category:** Core Classic | **Key Concepts:** Message Queue, Push/Pull, Fan-out, Rate Limiting

```
REQUIREMENTS:
- Send notifications via multiple channels: push (mobile), SMS, email.
- Handle high volume (millions of notifications per day).
- User preferences (opt-in/opt-out per channel).
- Exactly-once or at-least-once delivery.

HIGH-LEVEL DESIGN:
1. Trigger: event occurs (new message, order shipped, etc.) -> notification service.
2. Notification service: checks user preferences -> builds notification payload ->
   routes to the appropriate channel queue.
3. Channel workers: consume from queue -> call external provider (APNs, FCM, Twilio, SendGrid).

KEY COMPONENTS:
- Notification service: receives events, applies user preferences and rate limits.
- Message queues: one queue per channel (push queue, SMS queue, email queue).
  WHY: isolate failures (email provider down should not block push notifications).
- Template service: notification templates with variable substitution.
- User preferences DB: per-user, per-channel opt-in/out settings.
- Rate limiter: prevent notification spam (max N notifications per user per hour).

DEEP DIVES:
- Retry with exponential backoff for failed deliveries.
- Deduplication: idempotency key to prevent sending the same notification twice.
- Priority: urgent notifications (security alerts) bypass rate limits and get dedicated queues.
- Analytics: track delivery, open, click rates.
```

**Practice (NeetCode):** Design a Notification Service, Design an Email Service

---

### Step 22. Design a Search / Typeahead System
> **Category:** Core Classic | **Key Concepts:** Trie, Inverted Index, Elasticsearch, Caching

```
REQUIREMENTS:
- Full-text search across millions of documents/posts.
- Typeahead (autocomplete) as user types.
- Ranked results (relevance scoring).

FULL-TEXT SEARCH:
- Inverted index: maps each word -> list of document IDs containing that word.
  WHY: searching "design patterns" without an index requires scanning every document.
  With an inverted index, you look up "design" and "patterns", intersect the lists.
- Relevance scoring: TF-IDF, BM25, or ML-based ranking.
- Tools: Elasticsearch (built on Lucene), Apache Solr.
- Pattern: primary data in SQL/NoSQL, search index in Elasticsearch.
  Write to both (via message queue for async indexing).

TYPEAHEAD / AUTOCOMPLETE:
- Trie: prefix tree storing popular queries. Each node stores top-K completions.
  WHY: prefix lookup is O(length of prefix), and top-K results are precomputed.
- Data collection: log queries -> aggregate popularity -> rebuild trie periodically.
- Caching: cache the top results for common prefixes in Redis.
  Most users type the same few characters ("how to", "what is").

KEY DECISIONS:
- How often to update the search index? (Near real-time vs batch)
- How to handle typos? (Fuzzy matching, edit distance)
- Personalization? (Boost results based on user history)

RECOGNIZE IT: "search functionality", "autocomplete", "typeahead suggestions",
"find relevant posts/products".
```

**Practice (NeetCode):** Design a Search Engine, Design Typeahead / Autocomplete, Design Google Search

---

### Step 23. Design a Key-Value Store (e.g., Redis / DynamoDB)
> **Category:** Core Classic | **Key Concepts:** Consistent Hashing, Replication, Quorum, Gossip Protocol

```
REQUIREMENTS:
- put(key, value) and get(key) operations.
- High availability, low latency, scalable to billions of keys.
- Tunable consistency.

HIGH-LEVEL DESIGN:
1. Client sends request -> coordinator node (any node can be coordinator).
2. Coordinator uses consistent hashing to find the responsible nodes.
3. Replicate to N nodes. Read/write quorum determines consistency.

KEY COMPONENTS:
- Consistent hashing ring: distributes keys across nodes with virtual nodes.
- Replication: each key stored on N consecutive nodes on the ring.
- Quorum: W (write quorum) + R (read quorum) > N ensures strong consistency.
  W=1, R=1: fast but weak consistency. W=N, R=1: slow writes, fast consistent reads.
- Conflict resolution: vector clocks or last-write-wins for concurrent updates.
- Gossip protocol: nodes share membership and health info via periodic random pairwise exchanges.
- Merkle trees: efficiently detect and sync data differences between replicas.

WRITE PATH:
1. Write to commit log (durability).
2. Write to in-memory table (memtable).
3. When memtable is full, flush to disk as SSTable (sorted string table).
-> This is the LSM-tree (Log-Structured Merge-tree) architecture.

READ PATH:
1. Check memtable (in memory).
2. Check bloom filter (quick "probably not here" check).
3. Check SSTables on disk.
```

**Practice (NeetCode):** Design a Key-Value Store, Design DynamoDB, Design a Distributed Cache

---

### Step 24. Design a Rate Limiter
> **Category:** Core Classic | **Key Concepts:** Token Bucket, Sliding Window, Redis, Distributed Counting

```
REQUIREMENTS:
- Limit requests per client (by user_id, IP, API key) to N requests per time window.
- Low latency (rate check should not significantly slow down requests).
- Distributed (works across multiple servers).
- Accurate (no significant over-counting or under-counting).

HIGH-LEVEL DESIGN:
1. Request arrives at API gateway / middleware.
2. Rate limiter checks Redis: has this client exceeded their limit?
3. Under limit -> allow and increment counter. Over limit -> reject (HTTP 429).

ALGORITHM DEEP DIVE (Token Bucket -- recommended default):
- Each client has a bucket with capacity B tokens.
- Tokens are added at rate R per second.
- Each request consumes one token.
- If bucket is empty, request is rejected.
- Allows bursts of up to B requests, smooths to R requests/sec long-term.
- Redis implementation: store {last_refill_time, tokens_remaining} per client.

DISTRIBUTED CHALLENGES:
- Race conditions: two servers check the same counter simultaneously.
  Solution: Redis Lua script for atomic check-and-decrement.
- Centralized vs local: centralized (Redis) is accurate but adds latency.
  Local counters are fast but inaccurate across servers.

RESPONSE HEADERS:
- X-RateLimit-Limit: max requests per window
- X-RateLimit-Remaining: requests left in current window
- X-RateLimit-Retry-After: seconds until the client can retry
```

**Practice (NeetCode):** Design a Rate Limiter, Design an API Gateway

---

### Step 25. Design a Web Crawler
> **Category:** Core Classic | **Key Concepts:** BFS, Queue, Distributed Workers, Deduplication, Politeness

```
REQUIREMENTS:
- Crawl the web starting from seed URLs.
- Download pages, extract links, follow them (BFS traversal of the web graph).
- Avoid crawling the same page twice.
- Be polite (do not overload any single domain).

HIGH-LEVEL DESIGN:
1. URL Frontier (priority queue): stores URLs to crawl, ordered by priority.
2. Worker pool: distributed crawlers that fetch pages from the frontier.
3. Content parser: extracts links from downloaded HTML.
4. URL deduplication: checks if a URL has already been crawled or is in the frontier.
5. Data storage: store crawled pages for indexing.

KEY COMPONENTS:
- URL Frontier: not a simple queue -- it is a priority queue with politeness constraints.
  Per-domain queues ensure you do not hit the same domain too frequently.
  Priority based on PageRank, freshness, domain authority.
- Deduplication: bloom filter (probabilistic, memory-efficient) for "have I seen this URL?".
  Content hashing (fingerprint) to detect duplicate pages with different URLs.
- DNS resolver: cache DNS lookups (DNS is a bottleneck at scale).
- robots.txt: respect crawl directives. Cache per domain.

DEEP DIVES:
- Trap detection: infinite URL spaces (calendars, session IDs in URLs). Limit URL depth/length.
- Freshness: re-crawl pages periodically. Prioritize frequently changing pages.
- Distributed: partition URLs by domain hash across crawler instances.
```

**Practice (NeetCode):** Design a Web Crawler, Design Google Search (crawl + index + rank)

---

### Step 26. Design YouTube / Netflix (Video Streaming)
> **Category:** Core Classic | **Key Concepts:** Blob Storage, CDN, Transcoding, Adaptive Streaming

```
REQUIREMENTS:
- Upload videos.
- Stream videos with low latency and minimal buffering.
- Support multiple devices and network conditions.
- Scale to millions of concurrent viewers.

HIGH-LEVEL DESIGN:
Upload path:
1. Client uploads raw video to blob storage (via pre-signed URL).
2. Transcoding service converts to multiple formats/resolutions (1080p, 720p, 480p).
3. Transcoded segments stored in blob storage.
4. Video metadata (title, URL, thumbnails) stored in DB.

Streaming path:
1. Client requests video -> API returns video manifest (list of segment URLs).
2. Client fetches segments from CDN edge nodes.
3. Adaptive bitrate streaming (ABR): client monitors bandwidth and switches
   resolution mid-stream (HLS or DASH protocol).

KEY COMPONENTS:
- Transcoding pipeline: FFmpeg workers consuming from a job queue.
  Segment the video into small chunks (2-10 seconds) for parallel processing.
- CDN: critical for streaming. Popular videos cached at edge nodes worldwide.
- Blob storage: S3/GCS for raw and transcoded video segments.
- Adaptive bitrate: each resolution has its own set of segments.
  Client switches between them seamlessly based on network speed.

DEEP DIVES:
- Thumbnails: generate at key frames, store in blob storage, serve via CDN.
- Recommendations: separate ML service, feeds the home page.
- Live streaming: different from VOD. Uses RTMP ingest -> transcode in real-time -> HLS/DASH distribution.
- DRM: Digital Rights Management for copyrighted content.
```

**Practice (NeetCode):** Design YouTube, Design Netflix, Design a Video Streaming Service

---

### Step 27. Design Google Drive / Dropbox (File Storage & Sync)
> **Category:** Core Classic | **Key Concepts:** Blob Storage, Chunking, Sync, Conflict Resolution

```
REQUIREMENTS:
- Upload/download files.
- Sync files across multiple devices.
- Share files/folders with other users.
- Version history (restore previous versions).

HIGH-LEVEL DESIGN:
1. File is split into chunks (4-8 MB each).
2. Each chunk is hashed (SHA-256). Only modified chunks are uploaded (deduplication).
3. Chunks stored in blob storage. Metadata (file tree, chunk list, versions) in DB.
4. Sync service: detects local changes -> uploads changed chunks -> notifies other devices.

KEY COMPONENTS:
- Chunking: enables efficient sync (only upload changed portions of large files).
  Deduplication across files (if two files share a chunk, store it once).
- Metadata DB: file hierarchy, permissions, chunk manifests, version history.
  SQL for strong consistency (moving a file must be atomic).
- Notification service: when a file changes, notify other devices via WebSocket or long polling.
  Devices then pull the updated metadata and download changed chunks.
- Conflict resolution: if two devices edit the same file offline, keep both versions
  and let the user resolve (like Git conflicts).

DEEP DIVES:
- Compression: compress chunks before upload to save bandwidth and storage.
- Encryption: encrypt chunks client-side (end-to-end) or server-side.
- Sharing: ACL (access control list) per file/folder. Share via link with permissions (view/edit).
- Trash / versioning: soft delete, keep N versions, garbage collect old chunks.
```

**Practice (NeetCode):** Design Google Drive, Design Dropbox

---

### Step 28. Design a Distributed Task Scheduler
> **Category:** Infrastructure | **Key Concepts:** Job Queue, Leader Election, Sharding, Idempotency

```
REQUIREMENTS:
- Schedule tasks to run at a specific time or on a recurring schedule (cron-like).
- Distributed: multiple scheduler instances for availability.
- Exactly-once execution (or at-least-once with idempotent tasks).
- Handle millions of scheduled tasks.

HIGH-LEVEL DESIGN:
1. Client submits a task (payload + schedule).
2. Task stored in DB with next_run_time.
3. Scheduler polls for tasks where next_run_time <= now.
4. Scheduler dispatches tasks to worker pool via message queue.
5. Worker executes task, reports success/failure.

KEY COMPONENTS:
- Task DB: stores task definition, schedule, status, last_run, next_run.
  Index on next_run_time for efficient polling.
- Scheduler instances: multiple for HA. Use distributed locking or DB-level
  row locking to ensure each task is dispatched exactly once.
- Worker pool: stateless workers consuming from a task queue. Auto-scale based on queue depth.
- Retry logic: failed tasks retried with exponential backoff. Dead letter queue for poison pills.

KEY DECISIONS:
- Polling vs push: schedulers poll DB for due tasks (simple). Or use a delay queue
  (Redis ZRANGEBYSCORE with timestamps as scores).
- Sharding: partition tasks across scheduler instances by task_id hash.
  Each scheduler responsible for a subset of tasks.
- Exactly-once: use idempotency keys. Task table has a unique execution ID;
  workers check before executing.
```

**Practice (NeetCode):** Design a Task Scheduler, Design a Job Queue, Design Cron at Scale

---

### Step 29. Design a Metrics & Monitoring System (e.g., Datadog)
> **Category:** Infrastructure | **Key Concepts:** Time-Series DB, Aggregation, Alerting, Pull vs Push

```
REQUIREMENTS:
- Collect metrics from thousands of servers (CPU, memory, request latency, error rates).
- Store time-series data efficiently.
- Query and visualize metrics (dashboards, graphs).
- Alert when metrics cross thresholds.

HIGH-LEVEL DESIGN:
1. Agents on each server collect metrics and push to a metrics collector.
2. Collector writes to a time-series database.
3. Query service reads from TSDB for dashboards and alerts.
4. Alert service evaluates rules and sends notifications.

KEY COMPONENTS:
- Collection: push (agents send to collector) vs pull (collector scrapes /metrics endpoints).
  Pull (Prometheus model): easier to manage, collector knows all targets.
  Push (StatsD model): works behind firewalls, dynamic short-lived servers.
- Time-series DB: optimized for append-heavy, time-ordered data.
  Tools: InfluxDB, TimescaleDB, Prometheus.
  Compression: delta-of-delta for timestamps, XOR for values (Gorilla paper).
- Aggregation: roll up old data (1-second resolution for 1 day, 1-minute for 30 days,
  1-hour for 1 year). Saves storage while keeping recent data detailed.
- Alerting: rules engine evaluates conditions (e.g., "CPU > 90% for 5 minutes").
  Alert deduplication, routing (PagerDuty, Slack, email), escalation.
- Dashboards: Grafana-style visualization querying the TSDB.

DEEP DIVES:
- High cardinality: too many unique label combinations (user_id as a label) explodes storage.
  Solution: limit label cardinality, use sampling.
- Distributed: shard by metric name + time range across TSDB nodes.
```

**Practice (NeetCode):** Design a Metrics Collection System, Design Datadog, Design a Logging System

---

### Step 30. Design Ticketmaster / Booking System
> **Category:** Core Classic | **Key Concepts:** Concurrency, Distributed Locking, Idempotency, Seat Reservation

```
REQUIREMENTS:
- View available events and seats.
- Reserve and purchase tickets.
- Handle high concurrency (thousands booking simultaneously for popular events).
- No double-booking (one seat sold to exactly one person).

HIGH-LEVEL DESIGN:
1. User browses events and selects seats.
2. System temporarily holds the selected seats (e.g., 10-minute reservation).
3. User completes payment within the hold window.
4. On successful payment, seats are permanently assigned. On timeout, seats released.

KEY COMPONENTS:
- Event/Seat DB: SQL with row-level locking for seat status updates.
  Status: AVAILABLE -> HELD -> SOLD (or back to AVAILABLE on timeout).
- Temporary hold: Redis with TTL. SET seat_id user_id EX 600 NX.
  NX = only set if not exists (prevents double-hold). TTL auto-releases.
- Payment service: process payment, then update seat status to SOLD atomically.
- Queue for hot events: when thousands hit "buy" simultaneously, put requests in
  a queue and process sequentially. Show users their position in line.

KEY DECISIONS:
- Optimistic vs pessimistic locking:
  Optimistic: read seat version, attempt update with version check. Retry on conflict.
  Pessimistic: lock the row during the transaction. Simpler but limits throughput.
- Idempotency: payment retries must not charge twice. Use idempotency keys.
- Seat selection vs general admission: GA is simpler (just decrement a counter).
  Assigned seating requires per-seat state management.

DEEP DIVES:
- Waiting room / virtual queue: absorb traffic spikes for extremely popular events.
- Scalper prevention: CAPTCHA, purchase limits, identity verification.
- Inventory caching: cache available seat counts (eventually consistent) for browsing.
  Exact availability checked at reservation time.
```

**Practice (NeetCode):** Design Ticketmaster, Design a Hotel Booking System, Design an Airline Reservation System

---

## TIER 5: ADVANCED DESIGNS

Complex systems that push on multiple axes.

---

### Step 31. Design a Distributed Message Queue (e.g., Kafka)
> **Category:** Infrastructure | **Key Concepts:** Log-Based Storage, Partitioning, Consumer Groups, Replication

```
REQUIREMENTS:
- Producers publish messages to topics.
- Consumers subscribe to topics and process messages.
- High throughput (millions of messages per second).
- Durable (messages survive broker failures).
- Ordered within a partition.

HIGH-LEVEL DESIGN:
- Topic divided into partitions. Each partition is an ordered, immutable log.
- Producers append to partitions (round-robin or by key hash).
- Consumers read from partitions using an offset (their position in the log).

KEY COMPONENTS:
- Broker: server that stores partitions. Multiple brokers form a cluster.
- Partition: the unit of parallelism. More partitions = more throughput.
  Each partition is replicated across N brokers (leader + followers).
- Consumer group: group of consumers that divide partitions among themselves.
  Each partition consumed by exactly one consumer in a group (load balancing).
  Different groups can independently consume the same topic (fan-out).
- ZooKeeper/KRaft: manages broker metadata, leader election, consumer offsets.

WHY LOG-BASED:
- Sequential disk writes are fast (as fast as random memory access).
- Messages are immutable: append-only. No random updates.
- Consumers track their own offset. Messages are not deleted after consumption
  (retained for a configurable period). Enables replay.

DEEP DIVES:
- Exactly-once semantics: idempotent producers + transactional consumers.
- Compaction: for key-value topics, keep only the latest value per key.
- Backpressure: consumers that fall behind. Monitor consumer lag.
```

**Practice (NeetCode):** Design Kafka, Design a Message Queue, Design a Pub/Sub System

---

### Step 32. Design Google Maps / Location-Based Service
> **Category:** Advanced | **Key Concepts:** Geospatial Index, Graph Algorithms, Tile Rendering, ETA

```
REQUIREMENTS:
- Display maps (tiles).
- Search for places (restaurants, gas stations).
- Navigation: find the shortest/fastest route between two points.
- ETA estimation.

HIGH-LEVEL DESIGN:
1. Map tiles: pre-rendered at multiple zoom levels, served via CDN.
2. Place search: geospatial index to find nearby places.
3. Routing: graph algorithm on road network.
4. ETA: historical + real-time traffic data.

KEY COMPONENTS:
- Map tile service: pre-render tiles at each zoom level. Store in blob storage, serve via CDN.
  Tiling: divide the world into a grid (like Google's S2 cells or Uber's H3).
- Geospatial index: find "all restaurants within 5 km."
  Geohash: encode lat/lng into a string. Nearby points share a prefix.
  Quadtree: recursively divide 2D space. Good for variable density.
  R-tree: used by PostGIS, optimized for spatial range queries.
- Routing engine: road network as a weighted graph. Edges = road segments, weights = travel time.
  Precompute: Contraction Hierarchies or A* with landmarks for fast queries.
  Real-time: overlay live traffic data on edge weights.
- ETA service: ML model using historical travel times, current traffic, road type, time of day.
- Location tracking: drivers/users send GPS pings. Process via stream (Kafka) for real-time tracking.

DEEP DIVES:
- Caching: heavily cache tiles (they rarely change). Pre-fetch tiles for the user's viewport.
- Offline maps: pre-download tile + road graph data for a region.
- Live traffic: aggregate GPS data from all users to compute road speeds.
```

**Practice (NeetCode):** Design Google Maps, Design Uber/Lyft (location + routing), Design Yelp (nearby search)

---

### Step 33. Design a Distributed File System (e.g., HDFS / GFS)
> **Category:** Infrastructure | **Key Concepts:** Chunking, Replication, Master-Worker, Fault Tolerance

```
REQUIREMENTS:
- Store very large files (GBs to TBs) across a cluster of machines.
- Fault tolerant: files survive disk/machine failures.
- High throughput for sequential reads/writes (batch processing).

HIGH-LEVEL DESIGN (GFS/HDFS model):
1. Master (NameNode): stores file metadata (file -> list of chunks -> chunk locations).
   Single node, replicated for HA.
2. Chunk servers (DataNodes): store actual data chunks (64-128 MB each).
   Each chunk replicated to 3 chunk servers.

WRITE PATH:
1. Client asks master for chunk allocation.
2. Master assigns chunk servers, returns their addresses.
3. Client sends data to the primary chunk server.
4. Primary replicates to secondary chunk servers.
5. Once all replicas confirm, write is acknowledged.

READ PATH:
1. Client asks master which chunk servers have the desired chunk.
2. Client reads directly from the nearest chunk server.

KEY DECISIONS:
- Large chunk size (64-128 MB): reduces metadata size, amortizes network overhead.
  Trade-off: small files waste space, but GFS/HDFS is designed for large files.
- Replication factor of 3: survives two simultaneous failures. Rack-aware placement
  (replicas on different racks) survives rack-level failures.
- Master bottleneck: single master is a SPOF. Mitigate with standby master +
  persistent metadata log. Master only handles metadata (lightweight).

DEEP DIVES:
- Chunk server heartbeats: master detects dead chunk servers, re-replicates their chunks.
- Consistency: GFS uses leases for write ordering. One chunk server is the "primary"
  for each chunk, serializes writes.
- Erasure coding: alternative to 3x replication. Lower storage overhead (1.5x vs 3x)
  with same fault tolerance, but higher compute cost for encoding/decoding.
```

**Practice (NeetCode):** Design Google File System, Design HDFS, Design a Distributed Storage System

---

### Step 34. Design an E-Commerce Platform (e.g., Amazon)
> **Category:** Full System | **Key Concepts:** Microservices, Inventory, Payments, Search, Recommendations

```
REQUIREMENTS:
- Product catalog with search.
- Shopping cart and checkout.
- Order processing and payment.
- Inventory management (no overselling).
- User accounts and order history.

HIGH-LEVEL DESIGN (Microservices):
- User Service: authentication, profiles, addresses.
- Product Service: catalog, product details, categories.
- Search Service: Elasticsearch for product search, filters, autocomplete.
- Cart Service: per-user cart (Redis for active carts, DB for persistence).
- Order Service: order creation, status tracking, history.
- Payment Service: integration with payment gateway (Stripe, etc.).
- Inventory Service: track stock levels, reserve on order, release on cancellation.
- Notification Service: order confirmation, shipping updates.
- Recommendation Service: ML-based "customers also bought" suggestions.

KEY CHALLENGES:
- Inventory consistency: when two users buy the last item simultaneously,
  only one should succeed. Use optimistic locking or Redis atomic decrement.
- Payment reliability: idempotency keys prevent double-charging.
  Two-phase flow: reserve inventory -> charge payment -> confirm order.
  If payment fails, release inventory.
- Order state machine: CREATED -> PAID -> SHIPPED -> DELIVERED -> (RETURNED).
  Each transition triggers downstream actions (via event bus / message queue).

DEEP DIVES:
- Flash sales: spike traffic. Use queue-based throttling, pre-warm caches,
  separate hot-item inventory service.
- Search ranking: relevance + personalization + sponsored results.
- Reviews and ratings: separate service, eventual consistency for aggregated scores.
```

**Practice (NeetCode):** Design Amazon, Design an E-Commerce System, Design a Payment System

> **Note:** "Design a Payment System" is sometimes asked as a standalone question.
> Key focus areas: idempotency keys (prevent double-charging), payment state machine
> (INITIATED -> AUTHORIZED -> CAPTURED -> SETTLED or REFUNDED), reconciliation
> (match your records with payment provider records nightly), PCI compliance
> (never store raw card numbers -- use tokenization via Stripe/Braintree),
> and webhook handling (payment provider notifies you asynchronously of status changes).

---

### Step 35. Design Uber / Ride-Sharing
> **Category:** Advanced | **Key Concepts:** Location, Matching, Real-Time, Geospatial Index, ETA

```
REQUIREMENTS:
- Riders request rides. Drivers accept them.
- Match riders with nearby available drivers.
- Real-time tracking of driver location.
- ETA and fare estimation.
- Trip history and payments.

HIGH-LEVEL DESIGN:
1. Rider requests ride -> Ride Service finds nearby drivers -> sends ride offer.
2. Driver accepts -> match confirmed. Real-time tracking begins.
3. Trip completes -> fare calculated -> payment processed.

KEY COMPONENTS:
- Location service: drivers send GPS updates every few seconds.
  Store in-memory (Redis with geospatial commands: GEOADD, GEORADIUS).
  Process via Kafka stream for real-time tracking.
- Matching service: find available drivers within radius of rider.
  Rank by distance, ETA, rating. Send offer to best match.
  If declined, offer to next driver (with timeout).
- Trip service: manages trip lifecycle (REQUESTED -> MATCHED -> IN_PROGRESS -> COMPLETED).
- Fare service: base fare + distance + time + surge pricing.
  Surge pricing: multiply fare when demand > supply in an area.
- Payment service: charge rider, pay driver (minus platform fee).

KEY DECISIONS:
- Geospatial indexing: geohash or H3 hexagonal grid for efficient nearby queries.
  Partition the world into cells; query the cell and adjacent cells.
- Real-time updates: WebSocket for rider app (see driver moving on map).
  Driver app sends location updates via UDP or lightweight protocol.
- Surge pricing: divide city into zones, track supply/demand per zone in real-time.

DEEP DIVES:
- Supply positioning: predict demand, suggest drivers move to high-demand areas.
- Carpool / shared rides: match multiple riders going similar directions.
- Safety: trip sharing, emergency button, driver verification.
```

**Practice (NeetCode):** Design Uber, Design Lyft, Design a Food Delivery System (DoorDash)

---

## QUICK REFERENCE: WHICH BUILDING BLOCKS FOR WHICH DESIGN?

| Design Problem | Key Building Blocks |
|---|---|
| URL Shortener | Hashing, KV Store, Cache, Base62 encoding |
| Twitter / News Feed | Fan-out, Cache, Message Queue, Social Graph |
| Chat (WhatsApp) | WebSocket, Message Queue, Presence, Cassandra |
| Notification System | Message Queue, Fan-out, Rate Limiter, Templates |
| Search / Typeahead | Inverted Index, Trie, Elasticsearch, Cache |
| Key-Value Store | Consistent Hashing, Replication, Quorum, LSM-tree |
| Rate Limiter | Token Bucket, Redis, Sliding Window |
| Web Crawler | BFS Queue, Bloom Filter, robots.txt, DNS Cache |
| YouTube / Netflix | Blob Storage, CDN, Transcoding, Adaptive Streaming |
| Google Drive | Chunking, Blob Storage, Sync, Conflict Resolution |
| Task Scheduler | Job Queue, Leader Election, Distributed Lock |
| Monitoring | Time-Series DB, Aggregation, Alerting |
| Ticketmaster | Distributed Lock, Idempotency, Queue, Seat Hold |
| Kafka | Log-Based Storage, Partitions, Consumer Groups |
| Google Maps | Geospatial Index, Graph Routing, Tile CDN |
| Distributed File System | Chunking, Replication, Master-Worker, Fault Tolerance |
| E-Commerce | Microservices, Inventory Lock, Payment, Search |
| Uber | Geospatial Index, Real-Time Location, Matching, Surge |

---

## MEMORIZATION CHECKLIST

```
TIER 1 -- FOUNDATIONS (Building Blocks)
  [ ] 1.  Client-Server Model
  [ ] 2.  Databases (SQL vs NoSQL)
  [ ] 3.  Scaling: Vertical vs Horizontal
  [ ] 4.  Load Balancing
  [ ] 5.  Caching
  [ ] 6.  CDN
  [ ] 7.  API Design (REST, GraphQL, gRPC)
  [ ] 8.  Rate Limiting

TIER 2 -- DATA & STORAGE PATTERNS
  [ ] 9.  Database Replication
  [ ] 10. Database Sharding
  [ ] 11. Consistent Hashing
  [ ] 12. Message Queues
  [ ] 13. Blob / Object Storage

TIER 3 -- DISTRIBUTED SYSTEM CONCEPTS
  [ ] 14. CAP Theorem
  [ ] 15. Consensus & Leader Election
  [ ] 16. Unique ID Generation
  [ ] 17. Heartbeats & Failure Detection

TIER 4 -- CLASSIC SYSTEM DESIGNS
  [ ] 18. URL Shortener
  [ ] 19. News Feed / Twitter
  [ ] 20. Chat System (WhatsApp)
  [ ] 21. Notification System
  [ ] 22. Search / Typeahead
  [ ] 23. Key-Value Store
  [ ] 24. Rate Limiter
  [ ] 25. Web Crawler
  [ ] 26. YouTube / Netflix
  [ ] 27. Google Drive / Dropbox
  [ ] 28. Task Scheduler
  [ ] 29. Metrics & Monitoring
  [ ] 30. Ticketmaster / Booking

TIER 5 -- ADVANCED DESIGNS
  [ ] 31. Distributed Message Queue (Kafka)
  [ ] 32. Google Maps / Location Service
  [ ] 33. Distributed File System (GFS/HDFS)
  [ ] 34. E-Commerce (Amazon)
  [ ] 35. Uber / Ride-Sharing
```

For each step: (1) read the explanation until tradeoffs click, (2) draw the architecture from memory, (3) walk through the practice problems cold.
