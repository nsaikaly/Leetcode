# DSA + System Design Study Schedule

Based on: 2 hours/day, 4 days/week (8 hrs/week).
- **Days 1-3:** DSA using `neetcode_cheatsheet.md` + [NeetCode Roadmap](https://neetcode.io/roadmap)
- **Day 4:** System Design using `system_design.md` + [NeetCode System Design](https://neetcode.io/courses/system-design-for-beginners/0)

---

## Time Budget Reality Check

| Track          | Days/Week | Hrs/Week | Duration  | Total Hours |
|----------------|-----------|----------|-----------|-------------|
| DSA            | 3         | 6        | 22 weeks  | 132 hrs     |
| System Design  | 1         | 2        | 22 weeks  | 44 hrs      |
| **Combined**   | **4**     | **8**    | **22 weeks (~5 months)** | **176 hrs** |

**DSA need: ~120-135 hours** for 43 templates + ~140 problems + review.
**System Design need: ~40-45 hours** for 35 concepts/designs + practice.

**Verdict: 4 days/week finishes both tracks in ~5 months, running in parallel.**

---

## How Each Study Day Works

Every day follows this structure. The weekly plan tells you exactly what to do -- just plug it in.

```
DSA Day (Days 1-3) -- 2 hours:

  IF the day says "Learn Step X + solve problems":
    [0:00 - 0:25]  Read template in cheatsheet, understand the WHY
    [0:25 - 0:35]  Close file, rewrite the code from memory (repeat until clean)
    [0:35 - 2:00]  Solve the listed problems (time per problem varies, see weekly plan)

  IF the day is problems only (no new template):
    [0:00 - 0:10]  Quick re-code of most recent template from memory (warm-up)
    [0:10 - 2:00]  Solve the listed problems

  IF the day says "REVIEW":
    [0:00 - 0:30]  Re-code 3-5 templates from memory (no peeking)
    [0:30 - 2:00]  Re-solve previously struggled problems from scratch


System Design Day (Day 4) -- 2 hours:

  IF learning building blocks (Tiers 1-3, concepts):
    [0:00 - 0:40]  Read 2 concepts from system_design.md, understand the tradeoffs
    [0:40 - 1:00]  Close file, redraw each concept's key diagram from memory
    [1:00 - 2:00]  Walk through a practice problem using the concepts you just learned

  IF learning full designs (Tiers 4-5, classic designs):
    [0:00 - 1:00]  Read 1 design end-to-end, understand requirements -> architecture -> deep dives
    [1:00 - 1:15]  Close file, redraw the high-level architecture from memory
    [1:15 - 2:00]  Walk through the design out loud as if explaining to an interviewer
                   (cover: requirements, high-level, key components, deep dives, tradeoffs)

  IF the day says "REVIEW":
    [0:00 - 0:30]  Redraw 2-3 system architectures from memory
    [0:30 - 2:00]  Pick a design you haven't practiced and do a full mock (45 min timed)
```

**DSA time-box rule:** If stuck on a problem for 20 minutes with no progress, read the *approach* (not the code), then try again. If still stuck after 15 more minutes, read the full solution and re-solve from memory. Never spend more than 45 min on one problem.

---

## DSA Estimated Time Per Topic

These estimates assume you know programming but are new to DSA patterns.

```
Avg time per problem (for a beginner learning the pattern):
  Easy:    20-35 min   (Contains Duplicate, Valid Palindrome, Invert Binary Tree)
  Medium:  40-70 min   (3Sum, LRU Cache, Course Schedule)
  Hard:    60-120 min  (Trapping Rain Water, Alien Dictionary, Median of Two Sorted Arrays)

As you improve (after ~60 problems), these drop by ~40%:
  Easy:    10-20 min
  Medium:  25-40 min
  Hard:    40-75 min
```

| Topic                          | Steps | Difficulty | Template | Problems | Avg Min/Prob | Est. Hrs | Weeks |
|--------------------------------|-------|------------|----------|----------|--------------|----------|-------|
| Arrays & Hashing               | 1-3   | Easy-Med   | 1.5 hrs  | 10       | 30           | 7        | 1.5   |
| Two Pointers                   | 4-5   | Easy-Med   | 1 hr     | 7        | 35           | 5        | 1     |
| Sliding Window                 | 6-8   | Med        | 1.5 hrs  | 7        | 45           | 7        | 1.5   |
| Stack                          | 9-10  | Med        | 1 hr     | 6        | 40           | 5        | 1     |
| Binary Search                  | 11-12 | Med-Hard   | 1 hr     | 7        | 50           | 7        | 1.5   |
| Linked List                    | 13-14 | Med        | 1 hr     | 6        | 40           | 5        | 1     |
| Trees                          | 15-16 | Med-Hard   | 1.5 hrs  | 10       | 50           | 10       | 2     |
| Heap / Priority Queue          | 17-19 | Med-Hard   | 1.5 hrs  | 6        | 50           | 7        | 1.5   |
| Backtracking                   | 20    | Med-Hard   | 1 hr     | 6        | 55           | 6.5      | 1     |
| Tries                          | 21    | Med        | 0.5 hr   | 3        | 45           | 3        | 0.5   |
| Graphs                         | 22-25 | Med-Hard   | 2 hrs    | 10       | 55           | 11       | 2     |
| Advanced Graphs                | 26-29 | Hard       | 2 hrs    | 7        | 65           | 10       | 2     |
| Greedy                         | 30-31 | Med        | 1 hr     | 6        | 35*          | 4.5      | 1     |
| Intervals                      | 32-33 | Med        | 1 hr     | 5        | 30*          | 3.5      | 0.5   |
| Math & Geometry                | 34-36 | Easy-Med   | 1.5 hrs  | 6        | 25*          | 4        | 0.5   |
| Bit Manipulation               | 37-38 | Easy-Med   | 1 hr     | 5        | 25*          | 3        | 0.5   |
| Divide & Conquer               | 39-40 | Med        | 1 hr     | 4        | 35*          | 3.5      | 0.5   |
| LRU Cache / Rabin-Karp / BF    | 41-43 | Med-Hard   | 1.5 hrs  | 4        | 55           | 5        | 1     |
| Review & Mock                  | --    | Mixed      | --       | 12       | 25*          | 5        | 1     |
| **TOTAL**                      |       |            | **21 hrs** | **~140** |            | **~112** | **~21** |

*\* Times marked with \* reflect that by Weeks 15+, you are faster from accumulated experience.*

**Key insight:** Early topics (Arrays, Two Pointers) have simpler problems but you're slower as a beginner. Later topics (Greedy, Intervals, Bit Manipulation) have harder concepts but you solve faster because you've built pattern recognition. These roughly cancel out, except Graphs/Advanced Graphs which are both hard AND new -- that's where the most time goes.

---

## System Design Estimated Time Per Tier

| Tier                        | SD Steps | Topics                    | Min/Topic | Est. Hrs | Weeks |
|-----------------------------|----------|---------------------------|-----------|----------|-------|
| Tier 1: Building Blocks     | 1-8      | 8 concepts                | 30        | 4        | 4     |
| Tier 2: Data & Storage      | 9-13     | 5 concepts                | 35        | 3        | 3     |
| Tier 3: Distributed Systems | 14-17    | 4 concepts                | 35        | 2.5      | 2     |
| Tier 4: Classic Designs     | 18-30    | 13 full designs           | 60        | 13       | 9     |
| Tier 5: Advanced Designs    | 31-35    | 5 full designs            | 75        | 6.5      | 3     |
| Review & Mock               | --       | Full mock practice        | --        | 4        | 2     |
| **TOTAL**                   |          | **35 topics**             |           | **~33**  | **~23** |

Building block concepts (~30 min each) go fast. Full designs (~60-75 min each) need a full session. Later designs build on earlier concepts so they get easier to reason about.

---

## Week-by-Week Schedule (22 weeks / ~5 months)

Each week: **Days 1-3 = DSA, Day 4 = System Design**

### Phase 1: Foundations (Weeks 1-6)

DSA topics are easy-medium and you're a beginner, so ~30-45 min/problem. You can fit 2-3 problems + template learning per day. System Design covers building blocks (Tier 1).

#### Week 1: DSA: Arrays & Hashing Part 1 (Steps 1-2) | SD: Client-Server + Databases
```
  Day 1: Learn Step 1 (Frequency Count)
         + solve Contains Duplicate, Valid Anagram, Two Sum        [~30 min each, easy]
  Day 2: Solve Group Anagrams [med, ~45 min]
         Solve Top K Frequent Elements [med, ~45 min]
         Solve Valid Sudoku [med, ~40 min]
  Day 3: Learn Step 2 (Prefix Sum)
         + solve Product of Array Except Self [med]
         + solve Subarray Sum Equals K [med]
  Day 4: SD Steps 1-2 (Client-Server Model, Databases SQL vs NoSQL)
         Practice: sketch a basic web app architecture, discuss DB choice for Twitter
```

#### Week 2: DSA: Arrays & Hashing Part 2 + Two Pointers (Steps 3-4) | SD: Scaling + Load Balancing
```
  Day 1: Learn Step 3 (Prefix Sum + Hash Map)
         + solve Longest Consecutive Sequence [med]
         + solve Encode and Decode Strings [med]
  Day 2: Learn Step 4 (Left/Right)
         + solve Valid Palindrome [easy, ~20 min]
         + solve Two Sum II [med]
         + solve 3Sum [med, ~50 min]
  Day 3: Solve Container With Most Water [med, ~45 min]
         Solve Trapping Rain Water [hard, ~60 min]
  Day 4: SD Steps 3-4 (Vertical vs Horizontal Scaling, Load Balancing)
         Practice: design scaling strategy for 10M daily users
```

#### Week 3: DSA: Two Pointers Part 2 + Sliding Window (Steps 5-6) | SD: Caching + CDN
```
  Day 1: Learn Step 5 (Fast/Slow)
         + solve Linked List Cycle [easy, ~25 min]
         + solve Remove Nth Node From End [med]
         + solve Happy Number [easy, ~20 min]
  Day 2: Learn Step 6 (Variable Window)
         + solve Best Time to Buy and Sell Stock [easy, ~25 min]
         + solve Longest Substring Without Repeating Characters [med, ~45 min]
  Day 3: Solve Longest Repeating Character Replacement [med, ~50 min]
         Solve Minimum Window Substring [hard, ~60 min]
  Day 4: SD Steps 5-6 (Caching strategies + CDN)
         Practice: design caching layer for Twitter feed, discuss push vs pull CDN
```

#### Week 4: DSA: Sliding Window Part 2 + Stack (Steps 7-9) | SD: API Design + Rate Limiting
```
  Day 1: Learn Step 7 (Fixed Window) + Learn Step 8 (Monotonic Queue)
         + solve Sliding Window Maximum [hard, ~60 min]
  Day 2: Learn Step 9 (Stack Matching)
         + solve Valid Parentheses [easy, ~20 min]
         + solve Min Stack [med, ~35 min]
         + solve Evaluate Reverse Polish Notation [med, ~35 min]
  Day 3: Solve Generate Parentheses [med, ~45 min]
         Solve Daily Temperatures [med, ~40 min]
         Solve Car Fleet [med, ~40 min]
  Day 4: SD Steps 7-8 (API Design REST/GraphQL/gRPC, Rate Limiting)
         Practice: design Twitter API endpoints, discuss token bucket algorithm
```

#### Week 5: DSA: Monotonic Stack + Binary Search (Steps 10-12) | SD: Replication + Sharding
```
  Day 1: Learn Step 10 (Monotonic Stack)
         + solve Largest Rectangle in Histogram [hard, ~70 min]
  Day 2: Learn Step 11 (Lower Bound)
         + solve Binary Search [easy, ~15 min]
         + solve Search a 2D Matrix [med, ~35 min]
         + solve Find Minimum in Rotated Sorted Array [med, ~45 min]
  Day 3: Solve Search in Rotated Sorted Array [med, ~50 min]
         Solve Time Based Key-Value Store [med, ~50 min]
  Day 4: SD Steps 9-10 (Database Replication, Database Sharding)
         Practice: discuss shard key choices for a messenger app
```

#### Week 6: DSA: Binary Search on Answer + Review (Step 12) | SD: Consistent Hashing + Message Queues + Blob Storage
```
  Day 1: Learn Step 12 (BS on Answer)
         + solve Koko Eating Bananas [med, ~45 min]
         + solve Median of Two Sorted Arrays [hard, ~70 min]
  Day 2: REVIEW -- re-code DSA Steps 1-12 from memory (use cheatsheet checklist)
  Day 3: Re-solve 3 problems you struggled with most from Phase 1
  Day 4: SD Steps 11-13 (Consistent Hashing, Message Queues, Blob Storage)
         Practice: design a distributed cache with consistent hashing
```

**DSA Checkpoint: ~50 problems. Re-code all 12 templates from memory.**
**SD Checkpoint: Tier 1 + Tier 2 complete. You know all major building blocks.**

---

### Phase 2: Data Structures & Recursion (Weeks 7-12)

DSA topics get harder (trees, recursion, heaps). ~40-55 min/problem. System Design covers Tier 3 (distributed concepts) then starts Tier 4 (classic designs).

#### Week 7: DSA: Linked List (Steps 13-14) | SD: CAP Theorem + Consensus
```
  Day 1: Learn Step 13 (Reverse)
         + solve Reverse Linked List [easy, ~25 min]
         + solve Reverse Linked List II [med, ~45 min]
  Day 2: Learn Step 14 (Merge/Dummy Head)
         + solve Merge Two Sorted Lists [easy, ~25 min]
         + solve Add Two Numbers [med, ~45 min]
  Day 3: Solve Reorder List [med, ~50 min]
         Solve Copy List with Random Pointer [med, ~50 min]
  Day 4: SD Steps 14-15 (CAP Theorem, Consensus & Leader Election)
         Practice: discuss CP vs AP for a banking system vs social feed
```

#### Week 8: DSA: Trees Part 1 (Step 15) | SD: Unique IDs + Heartbeats
```
  Day 1: Learn Step 15 (Tree DFS)
         + solve Invert Binary Tree [easy, ~20 min]
         + solve Maximum Depth [easy, ~20 min]
         + solve Same Tree [easy, ~20 min]
  Day 2: Solve Diameter of Binary Tree [med, ~45 min]
         Solve Balanced Binary Tree [med, ~40 min]
         Solve Subtree of Another Tree [med, ~40 min]
  Day 3: Solve Validate BST [med, ~50 min]
         Solve Lowest Common Ancestor [med, ~55 min]
  Day 4: SD Steps 16-17 (Unique ID Generation, Heartbeats & Failure Detection)
         Practice: design Snowflake ID system for Twitter
```

**SD Checkpoint: Tiers 1-3 complete. All building blocks learned. Classic designs start next week.**

#### Week 9: DSA: Trees Part 2 + Heaps (Steps 16-17) | SD: URL Shortener
```
  Day 1: Solve Serialize and Deserialize Binary Tree [hard, ~70 min]
         Solve Construct BT from Preorder and Inorder [med, ~50 min]
  Day 2: Learn Step 16 (Tree BFS)
         + solve Level Order Traversal [med, ~35 min]
         + solve Right Side View [med, ~35 min]
         + solve Count Good Nodes [med, ~35 min]
  Day 3: Learn Step 17 (Top-K)
         + solve Kth Largest Element in a Stream [easy, ~25 min]
         + solve Last Stone Weight [easy, ~20 min]
         + solve K Closest Points [med, ~40 min]
  Day 4: SD Step 18 (Design URL Shortener)
         Practice: full design walkthrough -- requirements, Base62, caching, analytics
```

#### Week 10: DSA: Heaps Part 2 + Backtracking (Steps 18-20) | SD: Twitter / News Feed
```
  Day 1: Learn Step 18 (K-Way Merge)
         + solve Merge K Sorted Lists [hard, ~60 min]
  Day 2: Learn Step 19 (Two Heaps)
         + solve Find Median from Data Stream [hard, ~60 min]
         + solve Task Scheduler [med, ~45 min]
  Day 3: Learn Step 20 (Backtracking)
         + solve Subsets [med, ~40 min]
         + solve Combination Sum [med, ~45 min]
  Day 4: SD Step 19 (Design Twitter / News Feed)
         Practice: fan-out on write vs read, hybrid approach, timeline cache
```

#### Week 11: DSA: Backtracking Part 2 + Tries (Steps 20-21) | SD: Chat System
```
  Day 1: Solve Permutations [med, ~40 min]
         Solve Subsets II [med, ~40 min]
         Solve Combination Sum II [med, ~40 min]
  Day 2: Solve Word Search [med, ~50 min]
         Solve Palindrome Partitioning [med, ~55 min]
  Day 3: Learn Step 21 (Trie)
         + solve Implement Trie [med, ~40 min]
         + solve Design Add and Search Words [med, ~50 min]
  Day 4: SD Step 20 (Design Chat System / WhatsApp)
         Practice: WebSocket connections, message queue, presence, offline delivery
```

#### Week 12: DSA: Phase 2 Review | SD: Notification System + Search
```
  Day 1: REVIEW -- re-code DSA Steps 13-21 from memory
  Day 2: Re-solve 3 hardest DSA problems from Phase 2
  Day 3: Solve Word Search II [hard, ~70 min]
         Solve N-Queens [hard, ~60 min]                            -- stretch goals
  Day 4: SD Steps 21-22 (Notification System, Search / Typeahead)
         Practice: design notification routing, discuss inverted index + trie
```

**DSA Checkpoint: ~85 problems. Templates 1-21 from memory.**
**SD Checkpoint: 5 classic designs completed (URL Shortener, Twitter, Chat, Notifications, Search).**

---

### Phase 3: Graphs (Weeks 13-17)

Hardest DSA phase. ~50-65 min/problem. System Design continues with classic designs (1 per week).

#### Week 13: DSA: Core Graphs (Steps 22-24) | SD: Key-Value Store
```
  Day 1: Learn Step 22 (Graph BFS)
         + solve Rotting Oranges [med, ~45 min]
         + solve Clone Graph [med, ~45 min]
  Day 2: Learn Step 23 (Graph DFS)
         + solve Number of Connected Components [med, ~45 min]
         + solve Course Schedule [med, ~50 min]
  Day 3: Learn Step 24 (Grid BFS/DFS)
         + solve Number of Islands [med, ~40 min]
         + solve Max Area of Island [med, ~40 min]
  Day 4: SD Step 23 (Design Key-Value Store)
         Practice: consistent hashing, quorum reads/writes, LSM-tree write path
```

#### Week 14: DSA: Core Graphs Part 2 (Step 25) | SD: Rate Limiter + Web Crawler
```
  Day 1: Solve Surrounded Regions [med, ~50 min]
         Solve Pacific Atlantic Water Flow [med, ~55 min]
  Day 2: Learn Step 25 (Topological Sort)
         + solve Course Schedule II [med, ~50 min]
         + solve Alien Dictionary [hard, ~65 min]
  Day 3: Solve Word Ladder [hard, ~70 min]                        -- this one is tough, full day
  Day 4: SD Steps 24-25 (Design Rate Limiter, Design Web Crawler)
         Practice: token bucket in Redis, BFS crawl with politeness + dedup
```

#### Week 15: DSA: Advanced Graphs (Steps 26-27) | SD: YouTube / Netflix
```
  Day 1: Learn Step 26 (Union-Find)
         + solve Redundant Connection [med, ~50 min]
         + solve Graph Valid Tree [med, ~45 min]
  Day 2: Learn Step 27 (Dijkstra)
         + solve Network Delay Time [med, ~55 min]
  Day 3: Solve Cheapest Flights Within K Stops [med, ~60 min]
  Day 4: SD Step 26 (Design YouTube / Netflix)
         Practice: upload + transcode pipeline, CDN delivery, adaptive bitrate
```

#### Week 16: DSA: Advanced Graphs Part 2 + New Templates (Steps 28-29, 41) | SD: Google Drive + Task Scheduler
```
  Day 1: Learn Step 28 (0-1 BFS)
         + solve Swim in Rising Water [hard, ~65 min]
  Day 2: Learn Step 29 (Kruskal MST)
         + solve Min Cost to Connect All Points [med, ~50 min]
  Day 3: Learn Step 41 (LRU Cache)
         + solve LRU Cache [med, ~60 min]                         -- implementation heavy
  Day 4: SD Steps 27-28 (Design Google Drive, Design Task Scheduler)
         Practice: chunking + sync + conflict resolution, distributed job scheduling
```

#### Week 17: DSA: Remaining Templates + Review (Steps 42-43) | SD: Monitoring + Ticketmaster
```
  Day 1: Learn Step 42 (Rolling Hash)
         + solve Repeated DNA Sequences [med, ~45 min]
  Day 2: Learn Step 43 (Bellman-Ford)
         + solve Cheapest Flights [re-solve with BF, ~40 min]
  Day 3: REVIEW -- re-code DSA Steps 22-29, 41-43 from memory
         Re-solve 1-2 graph problems you struggled with
  Day 4: SD Steps 29-30 (Design Monitoring System, Design Ticketmaster)
         Practice: time-series DB + alerting, seat reservation + distributed locking
```

**DSA Checkpoint: ~115 problems. Graphs are done -- the rest is downhill.**
**SD Checkpoint: Tier 4 complete (13 classic designs). You can design most common systems.**

---

### Phase 4: Strategy & Toolkits (Weeks 18-20)

DSA topics are more formulaic and you're faster now. System Design covers Tier 5 (advanced designs).

#### Week 18: DSA: Greedy + Intervals (Steps 30-33) | SD: Kafka
```
  Day 1: Learn Step 30 + Step 31
         + solve Non-overlapping Intervals [med, ~35 min]
         + solve Jump Game [med, ~30 min]
         + solve Jump Game II [med, ~35 min]
  Day 2: Learn Step 32 (Interval Merge)
         + solve Merge Intervals [med, ~30 min]
         + solve Insert Interval [med, ~35 min]
         + solve Partition Labels [med, ~30 min]
  Day 3: Learn Step 33 (Line Sweep)
         + solve Meeting Rooms [easy, ~15 min]
         + solve Meeting Rooms II [med, ~30 min]
         + solve Valid Parenthesis String [med, ~35 min]
  Day 4: SD Step 31 (Design Kafka / Distributed Message Queue)
         Practice: partitions, consumer groups, log-based storage, exactly-once
```

#### Week 19: DSA: Math + Bit Manipulation + D&C (Steps 34-40) | SD: Google Maps + GFS
```
  Day 1: Learn Steps 34-36
         + solve Greatest Common Divisor of Strings [easy, ~15 min]
         + solve Pow(x,n) [med, ~30 min]
         + solve Rotate Image [med, ~35 min]
  Day 2: Learn Steps 37-38
         + solve Single Number [easy, ~10 min]
         + solve Missing Number [easy, ~10 min]
         + solve Counting Bits [easy, ~15 min]
         + solve Reverse Bits [easy, ~15 min]
         + solve Sum of Two Integers [med, ~35 min]
  Day 3: Learn Steps 39-40
         + solve Kth Largest Element [med, ~35 min]
         + solve Spiral Matrix [med, ~35 min]
         + solve Sort Colors [med, ~30 min]
  Day 4: SD Steps 32-33 (Design Google Maps, Design Distributed File System)
         Practice: geospatial indexing + routing, GFS chunking + replication
```

#### Week 20: DSA: Bonus + Catch-up | SD: E-Commerce + Uber
```
  Day 1: Review DSA Bonus A (Floyd) + Bonus B (Encoding)          -- already know the patterns
  Day 2: Solve remaining weak-area DSA problems (pick 3-4 mediums)
  Day 3: FULL DSA REVIEW -- re-code all 43 templates from memory (checklist in cheatsheet)
  Day 4: SD Steps 34-35 (Design E-Commerce / Amazon, Design Uber)
         Practice: inventory locking + payment flow, geospatial matching + surge pricing
```

**DSA Checkpoint: ~140 problems. All 43 templates memorized.**
**SD Checkpoint: All 35 system design topics complete.**

---

### Phase 5: Review & Mock Interviews (Weeks 21-22)

#### Week 21: Mixed Timed Practice
```
  Day 1: DSA -- 2 random mediums, 25 min each. Review mistakes.
  Day 2: DSA -- 1 hard + 1 medium, 50 min total.
  Day 3: DSA -- Re-solve any problems you failed this week.
  Day 4: SD REVIEW -- redraw 3 system architectures from memory
         Then: 45-min timed mock design (pick randomly from Tier 4-5)
```

#### Week 22: Final Mock Interviews
```
  Day 1: DSA -- Final template review, re-code any forgotten templates
  Day 2: DSA -- Timed mock: 2 mediums in 40 minutes
  Day 3: DSA -- Timed mock: 1 medium + 1 hard in 50 minutes
  Day 4: SD -- Full mock: pick a random design, 45 min timed
         Then: review the quick reference table in system_design.md
```

---

## Speed Expectations (When to Look at Solutions)

### DSA

| Phase       | Time Limit | What to Do When Stuck                                                                       |
|-------------|------------|---------------------------------------------------------------------------------------------|
| Weeks 1-4   | 45 min     | After 20 min stuck: read the approach (not code), try again for 15 min. Then read solution. |
| Weeks 5-12  | 35 min     | After 15 min stuck: check which pattern applies, try again. Read solution after 35 min.     |
| Weeks 13-20 | 30 min     | Should recognize pattern in 5 min. If stuck on implementation, check solution after 30 min. |
| Weeks 21-22 | 25 min     | Interview simulation. If you can't solve in 25 min, mark it for re-study.                   |

**Critical rule:** NEVER spend more than 45 minutes on a single problem. Looking at solutions is not cheating -- it is studying. Re-solve it the next day from memory.

### System Design

No strict time limit during learning. During mock practice (Weeks 21-22), target **45 minutes per design** (matching real interview format). Structure your answer:
- Requirements + estimates (5 min)
- High-level design (10 min)
- Detailed component design (15 min)
- Deep dives + tradeoffs (15 min)

---

## Spaced Repetition Schedule

### DSA Templates
```
Day 0:   Learn template, solve 1 problem
Day 1:   Re-code template from memory (no peeking)
Day 3:   Re-code again + solve 1 new problem with it
Day 7:   Re-code one more time
Day 14:  Final check -- if clean, it's locked in
```

### System Design Concepts
```
Day 0:   Learn concept, sketch the architecture
Day 7:   Redraw architecture from memory
Day 14:  Explain the design out loud (as if in an interview)
Day 28:  Final check -- if you can explain tradeoffs cold, it's locked in
```

Both are baked into the schedule via the review days.

---

## "Am I On Track?" Milestones

| Week | DSA Milestone                                                           | System Design Milestone                           |
|------|-------------------------------------------------------------------------|---------------------------------------------------|
| 3    | Hash map, prefix sum, two pointers, sliding window from memory. ~30.    | Know caching, CDN, load balancing, API design.    |
| 6    | Tier 1 complete. Recognize patterns for arrays/search/stack. ~50.       | All building blocks (Tiers 1-3) complete.         |
| 12   | Tiers 1-2 complete. Trees, heaps, backtracking, tries solid. ~85.      | 5 classic designs done (URL shortener thru search).|
| 17   | Tiers 1-3 complete. Graphs solid. BFS/DFS/Dijkstra/UF. ~115.          | All 13 classic designs done.                      |
| 20   | All 43 templates memorized. ~140 problems solved.                       | All 35 topics complete.                           |
| 22   | Interview ready. Mediums in 20-25 min. ~145+ problems.                  | Can whiteboard any classic design in 45 min.      |

---

## If You're Behind Schedule

- **1-2 weeks behind on DSA:** Use Day 4 for DSA catch-up for 1-2 weeks, pause system design temporarily.
- **1-2 weeks behind on SD:** Double up SD sessions (cover 2 designs in one session) for a couple weeks.
- **3+ weeks behind overall:** Add a 5th study day for 3 weeks to catch up.
- **Specific DSA topic is hard (usually Trees or Graphs):** Spend an extra week. Cut time from Phase 4 (Math/Bit are easier to cram).
- **System Design feels too abstract:** Watch the NeetCode system design videos alongside the sheet. Visual walkthroughs help.

## If You're Ahead of Schedule

- Add more DSA practice problems from the cheatsheet (each step lists 5-10).
- Start attempting Hard DSA problems.
- Do full 45-min timed system design mocks earlier.
- Practice explaining system designs out loud (to a friend, rubber duck, or recording yourself).
