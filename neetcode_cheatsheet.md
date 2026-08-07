# Algorithm Memorization Roadmap (Python)

DP intentionally omitted. No fluff -- just the code you need to write from memory.
Order follows the [NeetCode Roadmap](https://neetcode.io/roadmap) exactly.

## How to use this sheet

Each step is one algorithm template. For every step:
1. Read the English comments until the logic clicks.
2. Close the file and rewrite the code from memory.
3. Solve the practice problems without looking back.

Steps are ordered so each tier builds on the last. Do not skip ahead.

---

## TIER 1: FOUNDATIONS

NeetCode sections: Arrays & Hashing -> Two Pointers -> Sliding Window -> Stack -> Binary Search

---

### Step 1. Frequency Count (Hash Map)
> **Pattern:** Arrays & Hashing | **Time:** O(n) | **Space:** O(n)
> **When:** count occurrences, find duplicates, check if two things are anagrams

```py
# WHY: Without a map, checking "have I seen x?" requires re-scanning the whole
# list each time (O(n^2)). A hash map gives O(1) lookups, so one pass is enough.
# RECOGNIZE IT: any time a problem says "duplicate", "frequency", "count", or
# "how many times" -- reach for a hash map first.
freq = {}
for x in nums:
    # Build the count incrementally: we never need to look backward.
    if x in freq:
        freq[x] += 1
    else:
        freq[x] = 1
# Alternative one-liner: from collections import Counter; freq = Counter(nums)
```

**Practice:** Contains Duplicate, Valid Anagram, Two Sum, Group Anagrams, Top K Frequent Elements, Longest Consecutive Sequence, Valid Sudoku, Encode and Decode Strings, Set Matrix Zeroes, Detect Squares

---

### Step 2. Prefix Sum (1D)
> **Pattern:** Arrays & Hashing | **Time:** O(n) build, O(1) query | **Space:** O(n)
> **When:** many range-sum queries on a fixed array

```py
# WHY: Naive range sum re-adds elements every query (O(n) each). By precomputing
# running totals, ANY range sum becomes a single subtraction: O(1).
# KEY INSIGHT: sum(nums[l..r]) = "total up to r" minus "total up to l-1".
# That is exactly pref[r+1] - pref[l]. The extra 0 at the start avoids edge cases.
# RECOGNIZE IT: "range sum", "subarray sum", or repeated queries on the same array.
pref = [0]
for x in nums:
    # Each entry extends the running total by one more element.
    pref.append(pref[-1] + x)
# This one subtraction replaces a loop over nums[l..r].
range_sum = pref[r + 1] - pref[l]
```

**Practice:** Range Sum Query - Immutable, Product of Array Except Self, Subarray Sum Equals K, Maximum Subarray, Running Sum of 1D Array

---

### Step 3. Prefix Sum + Hash Map (Subarray Sum = k)
> **Pattern:** Arrays & Hashing | **Time:** O(n) | **Space:** O(n)
> **When:** count or detect subarrays whose sum equals a target

```py
# WHY: Brute force checks every (l, r) pair: O(n^2). Instead, note that if
# prefix[r] - prefix[l] == k, there is a subarray summing to k. So as we walk,
# we ask "has (current_prefix - k) appeared before?" -- that is a hash map lookup.
# This merges prefix sums (Step 2) with hash map lookups (Step 1) into one pass.
# RECOGNIZE IT: "subarray sum equals k", "count subarrays", "divisible by k".
prefix = 0
counts = {0: 1}  # empty prefix has sum 0, seen once
ans = 0
for x in nums:
    prefix += x
    need = prefix - k  # if this was a previous prefix, the gap sums to k
    if need in counts:
        ans += counts[need]
    counts[prefix] = counts.get(prefix, 0) + 1
```

**Practice:** Subarray Sum Equals K, Continuous Subarray Sum, Two Sum, Longest Consecutive Sequence, Find Pivot Index

---

### Step 4. Two Pointers (Left/Right)
> **Pattern:** Two Pointers | **Time:** O(n) | **Space:** O(1)
> **When:** sorted input, find a pair that meets a condition, shrink from both ends

```py
# WHY: On sorted data, two nested loops to check all pairs is O(n^2). But if the
# sum is too small, moving the left pointer right increases it; too large, moving
# the right pointer left decreases it. This skips all the pairs that can not work,
# giving O(n) with zero extra space.
# RECOGNIZE IT: sorted array + "pair/triplet with target", "maximize gap", or
# "container" problems where both ends matter.
l, r = 0, len(arr) - 1
while l < r:
    s = arr[l] + arr[r]
    if s < target:
        l += 1   # need a bigger sum -- move left pointer right
    elif s > target:
        r -= 1   # need a smaller sum -- move right pointer left
    else:
        break     # found the target pair
```

**Practice:** Valid Palindrome, Two Sum II, 3Sum, Container With Most Water, Trapping Rain Water

---

### Step 5. Fast/Slow Pointers (Runner)
> **Pattern:** Two Pointers | **Time:** O(n) | **Space:** O(1)
> **When:** find the middle of a linked list, detect a cycle

```py
# WHY: To find the middle, you would normally need the length (two passes). But
# if fast moves 2x and slow moves 1x, when fast reaches the end, slow is at the
# middle -- one pass, no counting. The same speed gap detects cycles: in a loop,
# fast eventually laps slow and they collide.
# RECOGNIZE IT: "middle of list", "cycle detection", "palindrome linked list"
# (split at middle, reverse second half, compare).
slow = fast = head
while fast and fast.next:
    slow = slow.next       # 1 step
    fast = fast.next.next  # 2 steps
# slow is now at the middle node.
```

**Practice:** Linked List Cycle, Middle of the Linked List, Palindrome Linked List, Find the Duplicate Number, Happy Number, Remove Nth Node From End of List

---

### Step 6. Sliding Window (Variable Size)
> **Pattern:** Sliding Window | **Time:** O(n) | **Space:** O(k)
> **When:** longest/shortest substring or subarray satisfying a constraint

```py
# WHY: Brute force checks every (l, r) substring: O(n^2). But once a window is
# valid, expanding right can only help (longer answer). Once invalid, shrinking
# left is the only way to fix it. So both pointers only move forward -- O(n).
# The window "slides" right; the left side chases to restore the constraint.
# RECOGNIZE IT: "longest substring with at most k ...", "smallest window containing
# ...", any problem where you grow/shrink a contiguous range.
count = {}
l = 0
for r, x in enumerate(s):
    count[x] = count.get(x, 0) + 1  # expand: include s[r]
    # Shrink from left until the window is valid again.
    while violates(count):
        left_ch = s[l]
        count[left_ch] -= 1
        if count[left_ch] == 0:
            del count[left_ch]  # keep map clean for accurate checks
        l += 1
    # Window [l, r] is valid -- update answer here (e.g., max length).
```

**Practice:** Best Time to Buy and Sell Stock, Longest Substring Without Repeating Characters, Longest Repeating Character Replacement, Permutation in String, Minimum Window Substring

---

### Step 7. Sliding Window (Fixed Size)
> **Pattern:** Sliding Window | **Time:** O(n) | **Space:** O(1)
> **When:** compute something over every contiguous window of exactly k elements

```py
# WHY: Recomputing the sum (or any aggregate) for every window from scratch is
# O(n*k). Instead, add the new right element and remove the element that just
# fell off the left. Each window update is O(1).
# RECOGNIZE IT: "window of size k", "maximum average of k elements", or any
# problem where k is fixed and you slide across the array.
window_sum = 0
best = -float("inf")
for i, x in enumerate(nums):
    window_sum += x                 # new element enters the window
    if i >= k:
        window_sum -= nums[i - k]  # old element leaves the window
    if i >= k - 1:
        best = max(best, window_sum)  # window is full -- check answer
```

**Practice:** Maximum Average Subarray I, Contains Duplicate II, Minimum Number of Flips to Make Binary String Alternating, Grumpy Bookstore Owner, Sliding Window Maximum

---

### Step 8. Monotonic Queue (Window Max/Min)
> **Pattern:** Sliding Window | **Time:** O(n) | **Space:** O(k)
> **When:** max or min inside a sliding window of size k

```py
from collections import deque

# WHY: Getting max of every window with a loop is O(n*k). A monotonic deque
# keeps candidates in decreasing order. The front is always the current max.
# When a bigger value arrives, smaller values can never be the max again, so
# we pop them. This ensures each element is pushed and popped at most once: O(n).
# RECOGNIZE IT: "sliding window maximum/minimum", or any window problem where
# you need the extreme value efficiently.
dq = deque()  # stores indices; values at those indices stay decreasing
res = []
for i, x in enumerate(nums):
    # Pop smaller values: they lose to x for as long as x is in the window.
    while dq and nums[dq[-1]] <= x:
        dq.pop()
    dq.append(i)
    # Remove indices that are outside the window.
    if dq[0] <= i - k:
        dq.popleft()
    # Once window is full, the front is the max.
    if i >= k - 1:
        res.append(nums[dq[0]])
```

**Practice:** Sliding Window Maximum, Longest Continuous Subarray With Absolute Diff <= Limit, Max Value of Equation, Shortest Subarray with Sum at Least K, Jump Game VI

---

### Step 9. Stack Matching / Parsing
> **Pattern:** Stack | **Time:** O(n) | **Space:** O(n)
> **When:** matching brackets, validating nested structure, evaluating expressions

```py
# WHY: Nested structures have a "last opened = first closed" property, which is
# exactly LIFO (stack). When a closer arrives, it MUST match the most recently
# opened thing. If it does not, the structure is broken immediately.
# RECOGNIZE IT: "valid parentheses", "decode string", "simplify path", any problem
# with nested matching or undo-style pairing.
pairs = {")": "(", "]": "[", "}": "{"}
stack = []
for ch in s:
    if ch in "([{":
        stack.append(ch)  # opener: remember it for later matching
    else:
        # Closer: it must match the most recent opener (stack top).
        if not stack or stack[-1] != pairs[ch]:
            return False  # mismatch or nothing to match -- invalid
        stack.pop()       # matched pair consumed
is_valid = (len(stack) == 0)  # all openers must be consumed
```

**Practice:** Valid Parentheses, Min Stack, Evaluate Reverse Polish Notation, Generate Parentheses, Daily Temperatures, Car Fleet

---

### Step 10. Monotonic Stack (Next Greater/Smaller)
> **Pattern:** Stack | **Time:** O(n) | **Space:** O(n)
> **When:** "next greater element", "next smaller element", histogram area

```py
# WHY: Brute force scans right from every element to find the next greater: O(n^2).
# A monotonic stack remembers elements still "waiting" for their answer. When a
# bigger value arrives, it resolves all smaller waiting elements at once. Each
# element is pushed once and popped once, so total work is O(n).
# RECOGNIZE IT: "next greater/warmer/taller", "largest rectangle", "stock span" --
# anything asking "what is the first thing to the right/left that beats me?"
stack = []  # stores indices; values at those indices stay in decreasing order
for i, x in enumerate(nums):
    # x is the "next greater" for everything smaller sitting on the stack.
    while stack and nums[stack[-1]] < x:
        j = stack.pop()  # j's answer is i
    stack.append(i)  # x waits for its own future "next greater"
```

**Practice:** Daily Temperatures, Next Greater Element I, Largest Rectangle in Histogram, Car Fleet, Online Stock Span

---

### Step 11. Lower Bound Binary Search
> **Pattern:** Binary Search | **Time:** O(log n) | **Space:** O(1)
> **When:** sorted array, find first position where a condition is true

```py
# WHY: Linear scan is O(n). Sorted data has a monotonic property: once the
# condition flips from false to true, it stays true. So we can halve the search
# space each step. This is the foundation of ALL binary search variants.
# KEY INSIGHT: l and r form a shrinking range. We maintain the invariant that the
# answer is always inside [l, r). When l == r, that is the answer.
# RECOGNIZE IT: "sorted array", "find first/last", "search insert position", or
# any time you can define a yes/no boundary.
def lower_bound(nums, target):
    l, r = 0, len(nums)  # answer is in [l, r)
    while l < r:
        m = (l + r) // 2
        if nums[m] < target:
            l = m + 1  # m is too small, answer is to the right
        else:
            r = m      # m might be the answer, keep it and search left
    return l  # first index where nums[i] >= target
```

**Practice:** Binary Search, Search a 2D Matrix, Find Minimum in Rotated Sorted Array, Search in Rotated Sorted Array, First Bad Version, Search Insert Position, Time Based Key-Value Store

---

### Step 12. Binary Search on Answer
> **Pattern:** Binary Search | **Time:** O(n log R) | **Space:** O(1)
> **When:** "minimize X such that ..." or "maximum X such that ..." with a yes/no feasibility check

```py
# WHY: Instead of searching inside the array, we search the ANSWER SPACE. If
# answer=5 works, then answer=6 also works (monotone). So we binary search for
# the smallest working answer. Each check calls a feasibility function: O(n).
# Total: O(n log R) where R is the answer range.
# RECOGNIZE IT: "minimize the maximum", "what is the least X such that", "can we
# do it in time T?" -- any optimization where feasibility is monotone.
lo, hi = min_possible, max_possible
while lo < hi:
    mid = (lo + hi) // 2
    if feasible(mid):
        hi = mid      # mid works -- maybe something smaller works too
    else:
        lo = mid + 1  # mid fails -- need something bigger
best = lo  # smallest feasible answer
```

**Practice:** Koko Eating Bananas, Capacity to Ship Packages Within D Days, Split Array Largest Sum, Magnetic Force Between Two Balls, Minimum Number of Days to Make m Bouquets, Median of Two Sorted Arrays

---

## TIER 2: DATA STRUCTURES AND RECURSION

NeetCode sections: Linked List -> Trees -> Heap / Priority Queue -> Backtracking -> Tries

---

### Step 13. Linked List Reverse
> **Pattern:** Linked List | **Time:** O(n) | **Space:** O(1)
> **When:** reverse a list or sublist, palindrome check on a list

```py
# WHY: Arrays can reverse by swapping ends, but linked lists have one-way pointers.
# The only way is to walk forward and flip each pointer as you go. Three variables
# (prev, cur, nxt) are enough because you only need to remember one step behind
# and one step ahead of the current node.
# RECOGNIZE IT: "reverse list", "reverse between positions l and r", "palindrome
# linked list" (reverse second half, compare), or any problem needing backward
# traversal in a singly-linked list.
prev, cur = None, head
while cur:
    nxt = cur.next       # save next before we break the forward link
    cur.next = prev      # flip: point this node backward
    prev, cur = cur, nxt # advance: prev takes cur's place, cur moves forward
# prev is now the new head (old tail).
head = prev
```

**Practice:** Reverse Linked List, Reverse Linked List II, Palindrome Linked List, Reorder List, Reverse Nodes in K-Group, Copy List with Random Pointer

---

### Step 14. Merge Two Sorted Lists (Dummy Head)
> **Pattern:** Linked List | **Time:** O(n+m) | **Space:** O(1)
> **When:** merge two sorted linked lists, base case for merge sort on lists

```py
# WHY: With arrays you can allocate a new output array, but with linked lists
# you just rewire existing node pointers. The dummy head trick eliminates the
# "first node" edge case: you always have a tail to append to.
# RECOGNIZE IT: "merge sorted lists", "merge k sorted", "sort a linked list"
# (merge sort uses this as its merge step).
dummy = ListNode(0)  # fake head so we never special-case the first append
tail = dummy
while l1 and l2:
    # Always pick the smaller head -- this keeps the merged list sorted.
    if l1.val <= l2.val:
        tail.next = l1
        l1 = l1.next
    else:
        tail.next = l2
        l2 = l2.next
    tail = tail.next
# One list is exhausted; the other still has sorted nodes -- just attach them.
tail.next = l1 if l1 else l2
merged_head = dummy.next  # skip the fake head
```

**Practice:** Merge Two Sorted Lists, Merge K Sorted Lists, Sort List, Add Two Numbers, Reorder List

---

### Step 15. Tree DFS (Recursive)
> **Pattern:** Trees | **Time:** O(n) | **Space:** O(h) where h = height
> **When:** path sums, subtree checks, any recursive tree question

```py
# WHY: Trees are recursive structures (each child is a smaller tree), so recursion
# is the natural fit. DFS visits every node exactly once. The placement of your
# work relative to the recursive calls gives you preorder (before), inorder
# (between), or postorder (after) -- each useful for different problems.
# RECOGNIZE IT: almost every tree problem. "Max depth" = postorder (need children
# first). "Serialize" = preorder. "BST in-order" = inorder gives sorted values.
def dfs(node):
    if not node:
        return  # base case: empty subtree contributes nothing
    # --- preorder: process node BEFORE children (top-down) ---
    dfs(node.left)
    # --- inorder: process node BETWEEN children (BST sorted order) ---
    dfs(node.right)
    # --- postorder: process node AFTER children (bottom-up, e.g., height) ---
```

**Practice:** Invert Binary Tree, Maximum Depth of Binary Tree, Diameter of Binary Tree, Balanced Binary Tree, Same Tree, Subtree of Another Tree, Lowest Common Ancestor, Validate BST, Serialize and Deserialize Binary Tree

> **BST tip:** In a BST, inorder traversal visits nodes in sorted order. Exploit this
> for "validate BST" (pass min/max bounds down), "kth smallest" (inorder until k),
> and "inorder successor" problems. No new algorithm -- just apply DFS with the
> ordering invariant: `left.val < node.val < right.val`.

---

### Step 16. Tree BFS (Level Order)
> **Pattern:** Trees | **Time:** O(n) | **Space:** O(n)
> **When:** level-by-level processing, minimum depth, zigzag traversal

```py
from collections import deque

# WHY: DFS goes deep first, which mixes up levels. BFS processes ALL nodes at
# depth d before any at depth d+1. This is essential when the problem cares about
# levels (e.g., "right side view" = last node per level, "min depth" = first leaf
# level). The queue ensures FIFO order, which naturally gives level ordering.
# RECOGNIZE IT: "level order", "minimum depth", "right side view", "zigzag",
# or any tree problem where depth/level matters.
q = deque([root])
while q:
    node = q.popleft()  # process the next node in FIFO order
    if node.left:
        q.append(node.left)   # children go to the back of the queue
    if node.right:
        q.append(node.right)  # so they are processed after this level
```

**Practice:** Binary Tree Level Order Traversal, Binary Tree Right Side View, Count Good Nodes in Binary Tree, Kth Smallest Element in a BST, Construct Binary Tree from Preorder and Inorder

---

### Step 17. Min-Heap Top-K
> **Pattern:** Heap / Priority Queue | **Time:** O(n log k) | **Space:** O(k)
> **When:** top-K elements, K closest points, Kth largest

```py
import heapq

# WHY: Sorting the whole array is O(n log n). But we only need k items. By
# maintaining a min-heap of size k, the smallest item in the heap is the "worst
# of the best." If a new item beats it, swap them. Total: O(n log k).
# KEY INSIGHT: a min-heap of size k always holds the k largest seen so far,
# because anything smaller has already been evicted.
# RECOGNIZE IT: "top k", "k closest", "kth largest", "k most frequent".
heap = []
for x in nums:
    heapq.heappush(heap, x)
    if len(heap) > k:
        heapq.heappop(heap)  # evict the smallest -- it is not in the top k
# heap now contains the k largest elements. heap[0] is the kth largest.
```

**Practice:** Kth Largest Element in a Stream, Last Stone Weight, K Closest Points to Origin, Kth Largest Element in an Array, Task Scheduler

---

### Step 18. K-Way Merge (Heap of Heads)
> **Pattern:** Heap / Priority Queue | **Time:** O(N log k) where N = total elements | **Space:** O(k)
> **When:** merge K sorted lists/streams into one sorted sequence

```py
import heapq

# WHY: Merging two sorted lists is O(n). Merging k lists by repeated two-way
# merge is O(N*k). A heap lets us always pick the global minimum across all k
# list heads in O(log k), giving O(N log k) total.
# KEY INSIGHT: the heap holds one element per list (the "head"). Each pop gives
# the next globally smallest element; then we push that list's next element.
# RECOGNIZE IT: "merge k sorted lists", "smallest range covering k lists".
heap = []
for i, lst in enumerate(lists):
    if lst:
        heapq.heappush(heap, (lst[0], i, 0))  # (value, which list, index in list)

merged = []
while heap:
    val, li, idx = heapq.heappop(heap)  # global smallest
    merged.append(val)
    if idx + 1 < len(lists[li]):
        nxt = lists[li][idx + 1]
        heapq.heappush(heap, (nxt, li, idx + 1))  # advance that list's head
```

**Practice:** Merge K Sorted Lists, Smallest Range Covering Elements from K Lists, Find K Pairs with Smallest Sums, Kth Smallest Element in a Sorted Matrix, Ugly Number II

---

### Step 19. Two Heaps (Streaming Median)
> **Pattern:** Heap / Priority Queue | **Time:** O(log n) per add | **Space:** O(n)
> **When:** find the median as numbers stream in, balance two halves

```py
import heapq

# WHY: Sorting after every insert is O(n log n). Instead, split numbers into a
# lower half (max-heap) and upper half (min-heap). The median is at the boundary.
# Balancing sizes ensures the median is always at one of the two tops.
# KEY INSIGHT: Python only has a min-heap, so we negate values for the max-heap.
# small[0] is the negated max of the lower half; large[0] is the min of the upper.
# RECOGNIZE IT: "find median from data stream", "sliding window median".
small = []  # max-heap of lower half (negate values)
large = []  # min-heap of upper half

def add_num(x):
    if not small or x <= -small[0]:
        heapq.heappush(small, -x)  # belongs in the lower half
    else:
        heapq.heappush(large, x)   # belongs in the upper half
    # Rebalance: sizes must differ by at most 1.
    if len(small) > len(large) + 1:
        heapq.heappush(large, -heapq.heappop(small))  # move max of lower to upper
    elif len(large) > len(small):
        heapq.heappush(small, -heapq.heappop(large))  # move min of upper to lower
```

**Practice:** Find Median from Data Stream, Sliding Window Median, IPO, Design Twitter, Reorganize String

---

### Step 20. Backtracking (Choose-Explore-Unchoose)
> **Pattern:** Backtracking | **Time:** O(2^n) subsets / O(n!) perms | **Space:** O(n)
> **When:** generate all subsets/permutations/combinations, constraint satisfaction

```py
# WHY: These problems REQUIRE exploring all possibilities. Backtracking does it
# systematically: at each position, try every valid option, recurse, then undo
# the choice so the next option starts from a clean slate.
# KEY INSIGHT: the recursion tree IS the search space. Each path from root to leaf
# is one candidate. Pruning (skipping invalid choices early) cuts whole subtrees.
# RECOGNIZE IT: "all subsets", "all permutations", "all combinations that sum to
# k", "N-Queens", "Sudoku" -- any problem asking for ALL valid configurations.
res, path = [], []

def backtrack(start):
    if goal_reached():
        res.append(path[:])  # [:] makes a copy -- path will keep changing
        return
    for i in range(start, len(nums)):
        path.append(nums[i])    # CHOOSE: add this element to the current path
        backtrack(i + 1)        # EXPLORE: recurse with the choice made
        path.pop()              # UNCHOOSE: undo so we can try the next option
```

**Practice:** Subsets, Combination Sum, Combination Sum II, Permutations, Subsets II, Word Search, Palindrome Partitioning, Letter Combinations of a Phone Number, N-Queens

---

### Step 21. Trie Insert / Search
> **Pattern:** Tries | **Time:** O(L) per word | **Space:** O(total chars)
> **When:** prefix matching, autocomplete, dictionary word lookups

```py
# WHY: A hash set can check "is this word in the dictionary?" in O(L), but it
# cannot answer "is there any word starting with this prefix?" without scanning
# all words. A trie stores words by their prefixes, so prefix queries are O(L).
# KEY INSIGHT: each node represents a prefix. Each edge is one character. Depth
# in the trie = length of the prefix. The .end flag marks complete words.
# RECOGNIZE IT: "implement trie", "word search in a board + dictionary",
# "autocomplete", "add and search with wildcards".
class TrieNode:
    def __init__(self):
        self.children = {}  # char -> TrieNode
        self.end = False    # True if a complete word ends at this node

def insert(root, word):
    node = root
    for ch in word:
        if ch not in node.children:
            node.children[ch] = TrieNode()  # create the path if it does not exist
        node = node.children[ch]            # walk down one character
    node.end = True  # mark: a complete word ends here
```

**Practice:** Implement Trie (Prefix Tree), Design Add and Search Words Data Structure, Word Search II, Longest Word in Dictionary, Replace Words

---

## TIER 3: GRAPHS

NeetCode sections: Graphs -> Advanced Graphs

---

### Step 22. Graph BFS (Shortest Path, Unweighted)
> **Pattern:** Graphs | **Time:** O(V+E) | **Space:** O(V)
> **When:** shortest path in an unweighted graph, level-by-level exploration

```py
from collections import deque

# WHY: In an unweighted graph, every edge has cost 1. BFS explores nodes in
# order of distance from the source: all distance-1 nodes, then distance-2, etc.
# So the FIRST time BFS reaches a node IS the shortest path to it.
# KEY INSIGHT: the visited set is critical -- without it, cycles cause infinite
# loops. Mark nodes as seen WHEN ENQUEUING, not when popping, to avoid duplicates.
# RECOGNIZE IT: "shortest path" (unweighted), "minimum steps", "rotting oranges"
# (multi-source BFS), "word ladder" (each word is a node).
q = deque([start])
seen = {start}  # mark seen immediately to avoid re-enqueuing
while q:
    u = q.popleft()
    for v in graph[u]:
        if v not in seen:
            seen.add(v)   # mark BEFORE enqueuing -- prevents duplicates
            q.append(v)
```

**Practice:** Rotting Oranges, Clone Graph, Word Ladder, Walls and Gates, Shortest Path in Binary Matrix, Open the Lock

> **Bidirectional BFS tip:** When both start and end are known (e.g., Word Ladder),
> run BFS from both ends simultaneously, expanding the smaller frontier each step.
> They meet in the middle, reducing search space from O(b^d) to O(b^(d/2)).
> Same base algorithm -- just two visited sets and two queues.

---

### Step 23. Graph DFS (Components, Reachability)
> **Pattern:** Graphs | **Time:** O(V+E) | **Space:** O(V)
> **When:** connected components, reachability, cycle detection (undirected)

```py
# WHY: DFS explores everything reachable from a start node. If we loop over ALL
# nodes and start DFS from each unvisited one, we discover every connected
# component. The number of DFS starts = number of components.
# KEY INSIGHT: the seen set is shared across all DFS calls, so each node is
# visited exactly once total. This keeps the total work at O(V+E).
# RECOGNIZE IT: "number of connected components", "is the graph connected?",
# "find all nodes reachable from X", "cycle in undirected graph".
seen = set()

def dfs(u):
    seen.add(u)  # mark visited so we never revisit
    for v in graph[u]:
        if v not in seen:
            dfs(v)  # go deeper -- explore everything reachable from v

# Start DFS from each unvisited node to find all components.
for u in nodes:
    if u not in seen:
        dfs(u)  # this is a new component
```

**Practice:** Number of Connected Components in an Undirected Graph, Graph Valid Tree, Pacific Atlantic Water Flow, Surrounded Regions, Course Schedule (cycle detection), Reconstruct Itinerary

---

### Step 24. Grid BFS/DFS (Matrix Traversal)
> **Pattern:** Graphs | **Time:** O(rows * cols) | **Space:** O(rows * cols)
> **When:** islands, flood fill, shortest path in a grid

```py
# WHY: A grid is just a graph where each cell is a node and edges connect to 4
# neighbors. DFS/BFS works the same way -- the only difference is bounds checking
# and using (row, col) instead of node IDs.
# KEY INSIGHT: the dirs array [(1,0),(-1,0),(0,1),(0,-1)] encodes "try all 4
# neighbors." The bounds check (0 <= nr < rows) replaces the adjacency list.
# RECOGNIZE IT: "number of islands", "flood fill", "shortest path in grid",
# "surrounded regions" -- any 2D matrix where you explore connected cells.
dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
rows, cols = len(grid), len(grid[0])
seen = [[False] * cols for _ in range(rows)]

for r in range(rows):
    for c in range(cols):
        if grid[r][c] == 1 and not seen[r][c]:
            # New component found (e.g., a new island). Explore it fully.
            stack = [(r, c)]
            seen[r][c] = True
            while stack:
                cr, cc = stack.pop()
                for dr, dc in dirs:
                    nr, nc = cr + dr, cc + dc
                    if 0 <= nr < rows and 0 <= nc < cols:  # bounds check
                        if grid[nr][nc] == 1 and not seen[nr][nc]:
                            seen[nr][nc] = True
                            stack.append((nr, nc))
```

**Practice:** Number of Islands, Max Area of Island, Surrounded Regions, Rotting Oranges, Pacific Atlantic Water Flow, Walls and Gates

---

### Step 25. Topological Sort (Kahn's BFS)
> **Pattern:** Graphs | **Time:** O(V+E) | **Space:** O(V)
> **When:** dependency/prerequisite ordering, cycle detection in a directed graph

```py
from collections import deque

# WHY: In a DAG, some tasks must happen before others. Kahn's algorithm peels off
# tasks with no remaining prerequisites (indegree 0). As each task is "completed,"
# it reduces the indegree of its dependents, potentially freeing them.
# KEY INSIGHT: if the final order has fewer nodes than the graph, a cycle exists
# (some nodes could never reach indegree 0). This is the standard cycle check for
# directed graphs.
# RECOGNIZE IT: "course schedule" (prerequisites), "build order", "alien
# dictionary" (character ordering), any DAG ordering problem.
q = deque([u for u in nodes if indeg[u] == 0])  # start with prerequisite-free nodes
order = []
while q:
    u = q.popleft()
    order.append(u)  # u is safe to process -- all its prerequisites are done
    for v in graph[u]:
        indeg[v] -= 1      # u is done, so v has one fewer prerequisite
        if indeg[v] == 0:
            q.append(v)     # v is now free -- all its prerequisites are done
# Cycle check: len(order) < len(nodes) means some nodes were stuck.
```

**Practice:** Course Schedule, Course Schedule II, Alien Dictionary, Minimum Height Trees, Longest Increasing Path in a Matrix

---

### Step 26. Union-Find (Disjoint Set Union)
> **Pattern:** Advanced Graphs | **Time:** O(alpha(n)) per op ~= O(1) | **Space:** O(n)
> **When:** "are these two nodes connected?", merging groups, cycle detection (edges), MST

```py
# WHY: BFS/DFS can answer "are A and B connected?" but takes O(V+E) each time.
# Union-Find answers it in near-O(1) by maintaining group leaders. When an edge
# is added, we merge two groups. Path compression keeps the tree flat.
# KEY INSIGHT: find() returns the group leader (root). Two nodes are connected
# iff they have the same leader. union() merges two groups by linking one root
# under the other. Rank keeps the tree balanced.
# RECOGNIZE IT: "redundant connection" (adding edge creates a cycle), "number of
# components" (dynamic), "accounts merge", MST (Kruskal uses this).
parent = {x: x for x in nodes}  # every node starts as its own leader
rank = {x: 0 for x in nodes}

def find(x):
    while x != parent[x]:
        parent[x] = parent[parent[x]]  # path compression: flatten the tree
        x = parent[x]
    return x  # the root/leader of x's group

def union(a, b):
    ra, rb = find(a), find(b)
    if ra == rb:
        return False  # already in the same group -- edge is redundant
    if rank[ra] < rank[rb]:
        ra, rb = rb, ra  # attach smaller tree under larger tree
    parent[rb] = ra
    if rank[ra] == rank[rb]:
        rank[ra] += 1  # tree got taller only when both had the same rank
    return True  # successfully merged two different groups
```

**Practice:** Redundant Connection, Number of Connected Components, Accounts Merge, Graph Valid Tree, Longest Consecutive Sequence (union-find approach)

---

### Step 27. Dijkstra (Shortest Path, Non-Negative Weights)
> **Pattern:** Advanced Graphs | **Time:** O((V+E) log V) | **Space:** O(V)
> **When:** shortest path in a graph where all edge weights >= 0

```py
import heapq

# WHY: BFS only works for unweighted graphs. With weights, a node that is "far"
# in hops might be "close" in total weight. Dijkstra fixes this by always
# expanding the node with the smallest TOTAL distance (greedy via a min-heap).
# KEY INSIGHT: once a node is popped from the heap, its distance is final (because
# all remaining paths are longer). The "if d != dist[u]: continue" line skips
# stale heap entries cheaply instead of doing expensive decrease-key.
# RECOGNIZE IT: "shortest path with weights", "network delay time", "cheapest
# flights", "minimum cost path" -- any non-negative weighted shortest path.
dist = {src: 0}
heap = [(0, src)]  # (distance, node)
while heap:
    d, u = heapq.heappop(heap)       # always expand the closest node
    if d != dist[u]:
        continue                      # stale entry -- we already found a shorter path
    for v, w in graph[u]:
        nd = d + w                    # candidate distance to v through u
        if nd < dist.get(v, float("inf")):
            dist[v] = nd              # found a shorter path to v
            heapq.heappush(heap, (nd, v))
```

**Practice:** Network Delay Time, Cheapest Flights Within K Stops, Swim in Rising Water, Path with Maximum Probability, Minimum Cost to Reach Destination in Time

---

### Step 28. 0-1 BFS (Deque Shortest Path)
> **Pattern:** Advanced Graphs | **Time:** O(V+E) | **Space:** O(V)
> **When:** shortest path when edge weights are only 0 or 1

```py
from collections import deque

# WHY: Dijkstra is O((V+E) log V) because of the heap. When weights are only 0
# or 1, we can use a deque instead: 0-cost edges go to the FRONT (process soon),
# 1-cost edges go to the BACK (process later). This mimics Dijkstra's ordering
# without a heap, giving O(V+E).
# KEY INSIGHT: this is a special case between BFS (unweighted) and Dijkstra
# (weighted). The deque maintains the invariant that distances are non-decreasing.
# RECOGNIZE IT: "grid with free/paid cells", "minimum flips", any 0/1 weight graph.
dist = [float("inf")] * n
dist[src] = 0
dq = deque([src])
while dq:
    u = dq.popleft()
    for v, w in graph[u]:
        nd = dist[u] + w
        if nd < dist[v]:
            dist[v] = nd
            if w == 0:
                dq.appendleft(v)  # free edge: high priority, process soon
            else:
                dq.append(v)      # cost-1 edge: lower priority, process later
```

**Practice:** Minimum Cost to Make at Least One Valid Path in a Grid, Shortest Path in Binary Matrix, Minimum Obstacle Removal to Reach Corner, Shortest Bridge, 01 Matrix

---

### Step 29. Kruskal MST (Sort Edges + Union-Find)
> **Pattern:** Advanced Graphs | **Time:** O(E log E) | **Space:** O(V)
> **When:** minimum spanning tree, connect all nodes at minimum total cost

```py
# WHY: To connect all nodes at minimum cost, always pick the cheapest available
# edge that does not create a cycle. Sorting gives us cheapest-first; Union-Find
# tells us if an edge would create a cycle (both endpoints already connected).
# KEY INSIGHT: an MST with n nodes has exactly n-1 edges. We stop early once we
# have that many. Uses Union-Find from Step 26.
# RECOGNIZE IT: "minimum cost to connect all points", "minimum spanning tree",
# "connect cities with minimum cost".
edges.sort(key=lambda e: e.w)  # cheapest edges first
total = 0
used = 0
for e in edges:
    if union(e.u, e.v):  # only add if it connects two DIFFERENT components
        total += e.w
        used += 1
        if used == n - 1:
            break  # MST complete -- n-1 edges connect n nodes
```

**Practice:** Min Cost to Connect All Points, Connecting Cities With Minimum Cost, Optimize Water Distribution in a Village, Find Critical and Pseudo-Critical Edges in MST, Minimum Cost to Reach City With Discounts

---

## TIER 4: STRATEGY AND TOOLKITS

NeetCode sections: Greedy -> Intervals -> Math & Geometry -> Bit Manipulation
Plus Divide & Conquer algorithms.

---

### Step 30. Greedy (Earliest Finish)
> **Pattern:** Greedy | **Time:** O(n log n) | **Space:** O(1)
> **When:** max non-overlapping intervals, min removals to eliminate overlaps

```py
# WHY: Sorting by end time ensures we always pick the interval that finishes
# earliest, leaving the maximum room for future intervals. This greedy choice is
# provably optimal: any other choice wastes more of the timeline.
# KEY INSIGHT: greedy works here because the locally best choice (earliest finish)
# never blocks a globally better solution. This is the "activity selection" proof.
# RECOGNIZE IT: "maximum number of non-overlapping intervals", "erase minimum
# intervals", "burst balloons with minimum arrows".
intervals.sort(key=lambda x: x[1])  # sort by END time
count, end = 0, float("-inf")
for s, e in intervals:
    if s >= end:
        count += 1  # this interval fits after the last one we took
        end = e      # update the "last end" to this interval's end
```

**Practice:** Non-overlapping Intervals, Minimum Number of Arrows to Burst Balloons, Maximum Length of Pair Chain, Partition Labels, Gas Station, Valid Parenthesis String

---

### Step 31. Greedy (Farthest Reach)
> **Pattern:** Greedy | **Time:** O(n) | **Space:** O(1)
> **When:** can you reach the end? minimum jumps to reach the end?

```py
# WHY: At each position, we know the farthest we could ever reach. If we land
# on a position beyond that, we are stuck. Otherwise, each position potentially
# extends the frontier. One pass through the array is enough.
# KEY INSIGHT: we do not need to track which jumps to take -- only the frontier.
# If the frontier reaches or passes the end, we can get there.
# RECOGNIZE IT: "jump game" (can you reach end?), "jump game II" (min jumps).
farthest = 0
for i, jump in enumerate(nums):
    if i > farthest:
        can_reach = False
        break              # stuck: this position is beyond our reach
    if i + jump > farthest:
        farthest = i + jump  # extend the frontier
else:
    can_reach = True
```

**Practice:** Jump Game, Jump Game II, Maximum Subarray, Gas Station, Hand of Straights

---

### Step 32. Interval Merge
> **Pattern:** Intervals | **Time:** O(n log n) | **Space:** O(n)
> **When:** merge overlapping intervals, insert into interval list

```py
# WHY: Once sorted by start, overlapping intervals are adjacent. We walk once:
# if the next interval overlaps the current merged one, extend it; otherwise,
# start a new merged interval. Sorting is the key that makes one pass sufficient.
# KEY INSIGHT: "overlap" means next.start <= current.end. Extending means
# current.end = max(current.end, next.end) to handle fully contained intervals.
# RECOGNIZE IT: "merge intervals", "insert interval", any problem that asks you
# to combine overlapping ranges.
intervals.sort()  # sort by start time
merged = []
for s, e in intervals:
    if not merged or merged[-1][1] < s:
        merged.append([s, e])                # no overlap: start fresh
    else:
        merged[-1][1] = max(merged[-1][1], e)  # overlap: extend the end
```

**Practice:** Merge Intervals, Insert Interval, Non-overlapping Intervals, Meeting Rooms, Minimum Interval to Include Each Query

---

### Step 33. Line Sweep (Event Counting)
> **Pattern:** Intervals | **Time:** O(n log n) | **Space:** O(n)
> **When:** max overlapping intervals, meeting rooms, most active time

```py
# WHY: Checking every time point is too slow. Instead, changes only happen at
# interval starts and ends. We convert each interval into two events: +1 at
# start, -1 at end. Sorting and sweeping these events tells us the active count
# at every transition point.
# KEY INSIGHT: the maximum of the running count is the peak overlap. For "meeting
# rooms II", the peak overlap = minimum rooms needed.
# RECOGNIZE IT: "minimum meeting rooms", "maximum overlap", "my calendar",
# "car pooling" -- any problem asking for peak concurrency.
events = []
for s, e in intervals:
    events.append((s, 1))   # interval starts: one more active
    events.append((e, -1))  # interval ends: one fewer active

events.sort()  # process events in chronological order
active = 0
best = 0
for _, delta in events:
    active += delta
    if active > best:
        best = active  # track the peak
```

**Practice:** Meeting Rooms, Meeting Rooms II, My Calendar I, Car Pooling, Minimum Number of Platforms

---

### Step 34. GCD / LCM
> **Pattern:** Math & Geometry | **Time:** O(log(min(a,b))) | **Space:** O(1)
> **When:** fraction simplification, repeating cycles, number theory

```py
import math

# WHY: GCD is the building block for many number theory problems. LCM is derived
# from GCD. The Euclidean algorithm (inside math.gcd) runs in O(log(min(a,b))).
# RECOGNIZE IT: "greatest common divisor of strings" (string repeats like a GCD),
# "simplify fraction", "LCM of array" (fold pairwise).
g = math.gcd(a, b)     # largest number that divides both a and b
lcm = a // g * b       # smallest number that both a and b divide into
# Note: a // g * b avoids overflow vs (a * b) // g
```

**Practice:** Greatest Common Divisor of Strings, Water Bottles, Fraction Addition and Subtraction, Ugly Number, Nth Tribonacci Number, Plus One, Rotate Image, Spiral Matrix

---

### Step 35. Sieve of Eratosthenes
> **Pattern:** Math & Geometry | **Time:** O(n log log n) | **Space:** O(n)
> **When:** find all primes up to n, count primes

```py
# WHY: Checking each number individually for primality is O(n * sqrt(n)). The
# sieve does it all at once: for each prime p, cross out all multiples of p.
# Starting from p*p is an optimization (smaller multiples were already crossed
# out by smaller primes).
# RECOGNIZE IT: "count primes up to n", "sieve", "prime factorization of many
# numbers" (precompute smallest prime factor variant).
def sieve(n):
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False
    for p in range(2, int(n ** 0.5) + 1):
        if is_prime[p]:
            for m in range(p * p, n + 1, p):  # start at p^2: smaller multiples done
                is_prime[m] = False
    return is_prime
```

**Practice:** Count Primes, Four Divisors, Closest Prime Numbers in Range, Ugly Number II, Sum of Four Divisors

---

### Step 36. Fast Exponentiation (Binary Power)
> **Pattern:** Math & Geometry | **Time:** O(log n) | **Space:** O(1)
> **When:** compute x^n efficiently, modular exponentiation

```py
# WHY: Naive x*x*x... is O(n) multiplications. By squaring the base and halving
# the exponent, we do O(log n) multiplications. This is essential for large
# exponents, especially in modular arithmetic (e.g., mod 10^9+7).
# KEY INSIGHT: any exponent can be written in binary. x^13 = x^(1101) =
# x^8 * x^4 * x^1. We square the base at each bit and multiply into the result
# when the bit is 1.
# RECOGNIZE IT: "pow(x, n)", "modular exponentiation", "matrix exponentiation".
def fast_pow(x, n):
    if n < 0:
        x = 1 / x
        n = -n
    res = 1
    base = x
    while n > 0:
        if n & 1:
            res *= base    # this bit is 1: multiply result by current power
        base *= base       # square the base for the next bit position
        n //= 2
    return res
```

**Practice:** Pow(x, n), Super Pow, Count Good Numbers, Modular Exponentiation (GFG), Multiply Strings

---

### Step 37. Bitmask Subset Enumeration
> **Pattern:** Bit Manipulation | **Time:** O(2^n * n) | **Space:** O(n)
> **When:** brute-force all subsets when n is small (<= 20)

```py
# WHY: Recursion can generate subsets, but bitmasks are simpler for enumeration.
# An n-bit integer has 2^n possible values, each representing one subset.
# Bit i being 1 means "include item i". This maps perfectly to subset selection.
# KEY INSIGHT: iterating 0 to 2^n-1 gives every possible include/exclude combo.
# This is often faster to write and debug than recursive backtracking.
# RECOGNIZE IT: "all subsets", "partition into groups", "state compression DP",
# any brute-force over subsets when n <= 20.
for mask in range(1 << n):  # 0 to 2^n - 1
    subset = [arr[i] for i in range(n) if mask & (1 << i)]
```

**Practice:** Subsets (bit approach), Counting Bits, Partition to K Equal Sum Subsets, Maximum Product of Word Lengths, Shortest Path Visiting All Nodes

---

### Step 38. XOR Cancellation (Find Unique)
> **Pattern:** Bit Manipulation | **Time:** O(n) | **Space:** O(1)
> **When:** every element appears twice except one -- find it

```py
# WHY: XOR has two key properties: a ^ a = 0 (self-cancellation) and a ^ 0 = a
# (identity). XOR-ing all elements cancels every pair, leaving only the unique one.
# No extra space, no sorting, no hash map needed.
# KEY INSIGHT: XOR is both commutative and associative, so order does not matter.
# This extends to "missing number" (XOR indices and values) and other variants.
# RECOGNIZE IT: "single number", "missing number", "find two unique numbers".
xor_all = 0
for x in nums:
    xor_all ^= x     # pairs cancel to 0; the unique element survives
unique = xor_all
```

**Practice:** Single Number, Number of 1 Bits, Counting Bits, Reverse Bits, Missing Number, Sum of Two Integers

---

### Step 39. Merge Sort
> **Pattern:** Divide and Conquer | **Time:** O(n log n) | **Space:** O(n)
> **When:** stable sort needed, count inversions, sort linked list

```py
# WHY: Merge sort guarantees O(n log n) worst case (unlike quicksort's O(n^2)
# worst case) and is stable (equal elements keep their original order). It is
# also the only efficient sort for linked lists (no random access needed).
# KEY INSIGHT: splitting is trivial (just find the middle). The real work is in
# the merge: two sorted halves combine into one sorted whole in O(n) by always
# picking the smaller head.
# RECOGNIZE IT: "sort an array" (stable), "count inversions" (count during merge),
# "sort linked list" (merge sort is ideal for lists).
def merge_sort(arr):
    if len(arr) <= 1:
        return arr  # base case: a single element is already sorted
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])    # sort the left half
    right = merge_sort(arr[mid:])   # sort the right half
    return merge(left, right)

def merge(left, right):
    i = j = 0
    out = []
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:     # <= makes the sort stable
            out.append(left[i])
            i += 1
        else:
            out.append(right[j])
            j += 1
    out.extend(left[i:])   # remaining elements from left half
    out.extend(right[j:])  # remaining elements from right half
    return out
```

**Practice:** Sort an Array, Sort List, Count of Smaller Numbers After Self, Reverse Pairs, Merge K Sorted Lists

---

### Step 40. Quickselect (Kth Element)
> **Pattern:** Divide and Conquer | **Time:** O(n) average | **Space:** O(1)
> **When:** find the Kth smallest/largest without fully sorting

```py
# WHY: Sorting finds the kth element in O(n log n). Quickselect does it in O(n)
# average by only recursing into the side that contains k. It uses the same
# partition as quicksort but throws away half the work each time.
# KEY INSIGHT: after partitioning, the pivot is in its final sorted position. If
# that position is k, we are done. Otherwise, recurse into the side containing k.
# RECOGNIZE IT: "kth largest element", "top k frequent" (quickselect on frequencies),
# any problem asking for the kth order statistic without needing full sort.
def partition(nums, lo, hi):
    pivot = nums[hi]
    i = lo  # i tracks where the next "small" element should go
    for j in range(lo, hi):
        if nums[j] <= pivot:
            nums[i], nums[j] = nums[j], nums[i]
            i += 1
    nums[i], nums[hi] = nums[hi], nums[i]  # pivot goes to its final position
    return i

def quickselect(nums, k):
    lo, hi = 0, len(nums) - 1
    while True:
        p = partition(nums, lo, hi)
        if p == k:
            return nums[p]   # pivot landed exactly at position k
        if p < k:
            lo = p + 1       # k is in the right half
        else:
            hi = p - 1       # k is in the left half
```

**Practice:** Kth Largest Element in an Array, Top K Frequent Elements, K Closest Points to Origin, Wiggle Sort II, Sort Colors

---

## TIER 5: ADDITIONAL CORE TEMPLATES

These don't fall into a single NeetCode section but are commonly tested at FAANG-level interviews.

---

### Step 41. LRU Cache (HashMap + Doubly Linked List)
> **Pattern:** Design | **Time:** O(1) get/put | **Space:** O(capacity)
> **When:** design a cache with O(1) access and eviction of least-recently-used item

```py
# WHY: A hash map gives O(1) lookup, but has no ordering. A linked list maintains
# insertion/access order, but has O(n) lookup. Combining both gives O(1) for
# everything: the map points directly to list nodes, and the list tracks recency.
# KEY INSIGHT: on every get or put, move the node to the head (most recent). When
# capacity is exceeded, evict the tail (least recent). The dummy head/tail trick
# eliminates edge cases.
# RECOGNIZE IT: "LRU cache", "design a cache with eviction", any problem needing
# O(1) access + O(1) ordering.
class Node:
    def __init__(self, key=0, val=0):
        self.key, self.val = key, val
        self.prev = self.next = None

class LRUCache:
    def __init__(self, capacity):
        self.cap = capacity
        self.cache = {}          # key -> Node
        self.head = Node()       # dummy head (most recent side)
        self.tail = Node()       # dummy tail (least recent side)
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev

    def _insert_front(self, node):
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key):
        if key not in self.cache:
            return -1
        node = self.cache[key]
        self._remove(node)          # detach from current position
        self._insert_front(node)    # move to front (most recent)
        return node.val

    def put(self, key, value):
        if key in self.cache:
            self._remove(self.cache[key])
        node = Node(key, value)
        self.cache[key] = node
        self._insert_front(node)
        if len(self.cache) > self.cap:
            lru = self.tail.prev    # least recently used = just before dummy tail
            self._remove(lru)
            del self.cache[lru.key]
```

**Practice:** LRU Cache, LFU Cache, Design Browser History, All O(1) Data Structure, Design Twitter

---

### Step 42. Rolling Hash (Rabin-Karp)
> **Pattern:** Strings / Hashing | **Time:** O(n+m) average | **Space:** O(1)
> **When:** substring search, detect duplicate substrings, pattern matching

```py
# WHY: Naive substring search compares every position character-by-character:
# O(n*m). A rolling hash computes a hash for the window and slides it in O(1) per
# step. Only when hashes match do we verify character-by-character (rare with a
# good hash). Average case: O(n+m).
# KEY INSIGHT: the hash is a polynomial: h = s[0]*base^(m-1) + s[1]*base^(m-2) + ...
# Sliding the window: remove the leftmost char's contribution, shift, add the new
# char. The modulus keeps numbers manageable.
# RECOGNIZE IT: "find substring", "repeated DNA sequences", "longest duplicate
# substring", any problem matching a pattern across a string.
def rabin_karp(text, pattern):
    n, m = len(text), len(pattern)
    if m > n:
        return -1
    base, mod = 31, 10**9 + 7
    # Precompute base^(m-1) mod p for removing the leading character.
    power = pow(base, m - 1, mod)

    # Hash the pattern and the first window.
    p_hash = t_hash = 0
    for i in range(m):
        p_hash = (p_hash * base + ord(pattern[i])) % mod
        t_hash = (t_hash * base + ord(text[i])) % mod

    for i in range(n - m + 1):
        if t_hash == p_hash and text[i:i + m] == pattern:
            return i  # match found at index i
        # Slide the window: remove text[i], add text[i + m].
        if i + m < n:
            t_hash = (t_hash - ord(text[i]) * power) % mod
            t_hash = (t_hash * base + ord(text[i + m])) % mod
    return -1
```

**Practice:** Repeated DNA Sequences, Longest Duplicate Substring, Find All Anagrams in a String, Shortest Palindrome, Longest Happy Prefix

---

### Step 43. Bellman-Ford (Shortest Path, Negative Weights)
> **Pattern:** Advanced Graphs | **Time:** O(V*E) | **Space:** O(V)
> **When:** shortest path with negative weights, or shortest path with at most K edges

```py
# WHY: Dijkstra fails with negative edge weights (its greedy assumption breaks).
# Bellman-Ford relaxes ALL edges V-1 times. After round i, shortest paths using
# at most i edges are correct. After V-1 rounds, all shortest paths are found.
# KEY INSIGHT: the K-stops variant (Cheapest Flights Within K Stops) just limits
# the number of relaxation rounds to K+1. Copy the dist array each round to
# prevent using paths longer than allowed.
# RECOGNIZE IT: "cheapest flights with at most K stops", "negative weight edges",
# "detect negative cycle" (if V-th round still improves, there is a negative cycle).
def bellman_ford(n, edges, src):
    dist = [float("inf")] * n
    dist[src] = 0
    for _ in range(n - 1):          # V-1 rounds
        for u, v, w in edges:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w   # relax edge u -> v
    return dist

# K-stops variant: only K+1 relaxation rounds, copy dist each round.
def cheapest_k_stops(n, edges, src, dst, k):
    dist = [float("inf")] * n
    dist[src] = 0
    for _ in range(k + 1):
        prev = dist[:]              # snapshot: only use paths from previous round
        for u, v, w in edges:
            if prev[u] + w < dist[v]:
                dist[v] = prev[u] + w
    return dist[dst] if dist[dst] < float("inf") else -1
```

**Practice:** Cheapest Flights Within K Stops, Network Delay Time, Negative Weight Cycle (GFG), Shortest Path in a Grid with Obstacles Elimination, Path with Maximum Probability

---

## BONUS: ONE-OFF ALGORITHMS

Not tied to a single NeetCode section but show up enough to memorize.

---

### Bonus A. Floyd Cycle Detection (Tortoise and Hare)
> **Time:** O(n) | **Space:** O(1)
> **When:** detect a cycle in a linked list or repeated function values

```py
# WHY: A hash set can detect cycles in O(n) space. Floyd's algorithm does it in
# O(1) space using two pointers at different speeds. If there is a cycle, the
# fast pointer eventually laps the slow pointer and they collide inside the cycle.
# RECOGNIZE IT: "linked list cycle", "find duplicate number" (array as linked list),
# any problem where following "next" pointers might loop forever.
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
    if slow == fast:
        break  # collision inside the cycle
# To find the cycle START: reset one pointer to head, then move both at speed 1.
# They meet at the cycle entrance. (Math: both have traveled the same distance
# mod cycle length.)
```

**Practice:** Linked List Cycle, Linked List Cycle II, Find the Duplicate Number, Happy Number, Circular Array Loop

---

### Bonus B. Length-Prefix Encoding/Decoding
> **Time:** O(total length) | **Space:** O(total length)
> **When:** serialize/deserialize a list of strings without ambiguity

```py
# WHY: Simple delimiters (like commas) fail when the strings themselves contain
# the delimiter. Length-prefixing is unambiguous: the length tells you exactly
# how many characters to read, so the content cannot confuse the parser.
# RECOGNIZE IT: "encode and decode strings" -- the NeetCode 150 version.
def encode(strs):
    out = []
    for s in strs:
        out.append(str(len(s)) + "#" + s)  # "length#content"
    return "".join(out)

def decode(s):
    res = []
    i = 0
    while i < len(s):
        j = i
        while s[j] != "#":
            j += 1
        length = int(s[i:j])                    # read the length
        word = s[j + 1 : j + 1 + length]        # read exactly that many chars
        res.append(word)
        i = j + 1 + length                      # advance past this encoded string
    return res
```

**Practice:** Encode and Decode Strings, Serialize and Deserialize Binary Tree, Codec for Strings, Design TinyURL, String Compression

---

## SECONDARY TEMPLATES

Less common but still worth knowing. Memorize these after the 40 steps above.

---

### Prefix Sum (2D)
> **Pattern:** Arrays & Hashing | **Time:** O(rows*cols) build, O(1) query
> **When:** many sub-rectangle sum queries on a fixed matrix

```py
# WHY: Same idea as 1D prefix sums but in 2D. Inclusion-exclusion on 4 corners
# gives any sub-rectangle sum in O(1) after an O(rows*cols) precomputation.
rows, cols = len(matrix), len(matrix[0])
pref2 = [[0] * (cols + 1) for _ in range(rows + 1)]  # 1-based padding
for r in range(1, rows + 1):
    for c in range(1, cols + 1):
        pref2[r][c] = (
            matrix[r - 1][c - 1]
            + pref2[r - 1][c]      # top
            + pref2[r][c - 1]      # left
            - pref2[r - 1][c - 1]  # subtract overlap (counted twice)
        )
# Query: sum of sub-rectangle (r1,c1) to (r2,c2) inclusive.
total = (
    pref2[r2 + 1][c2 + 1]
    - pref2[r1][c2 + 1]
    - pref2[r2 + 1][c1]
    + pref2[r1][c1]
)
```

---

### Difference Array (Range Update)
> **Pattern:** Arrays & Hashing | **Time:** O(n + q) | **Space:** O(n)
> **When:** many "add delta to range [l,r]" updates, then read final array once

```py
# WHY: Applying each update to every element is O(n*q). A difference array records
# only the change points (+delta at start, -delta after end). One prefix sum pass
# at the end gives the final values. Each update is O(1).
diff = [0] * (n + 1)
for l, r, delta in updates:
    diff[l] += delta
    if r + 1 < n:
        diff[r + 1] -= delta

res = [0] * n
running = 0
for i in range(n):
    running += diff[i]
    res[i] = running
```

---

### Canonical Key + Bucket Grouping
> **Pattern:** Arrays & Hashing | **Time:** O(n * key_cost) | **Space:** O(n)
> **When:** group items that are "equivalent" (anagrams, same structure, etc.)

```py
# WHY: To group, we need a label that is the SAME for equivalent items and
# DIFFERENT for non-equivalent items. Sorting a string gives a canonical form;
# all anagrams share the same sorted form. The key must be hashable (tuple, not list).
groups = {}
for item in items:
    key = build_key(item)  # e.g., tuple(sorted(item)) for anagrams
    if key not in groups:
        groups[key] = []
    groups[key].append(item)
result = list(groups.values())
```

---

### Cyclic Sort / Index Sign Marking
> **Pattern:** Arrays & Hashing | **Time:** O(n) | **Space:** O(1)
> **When:** values in range 1..n, find missing/duplicate using the array itself as a hash

```py
# WHY: When values are in 1..n and the array has n slots, each value has a "home"
# index (x lives at index x-1). Swapping values to their homes lets us find
# missing/duplicate numbers without extra space.
# --- Cyclic sort: put value x at index x-1 ---
i = 0
while i < len(nums):
    x = nums[i]
    if 1 <= x <= len(nums):
        correct = x - 1
        if nums[correct] != x:
            nums[i], nums[correct] = nums[correct], nums[i]
            continue
    i += 1

# --- Index sign marking: negate index x-1 to mark x as seen ---
for i in range(len(nums)):
    x = abs(nums[i])
    if 1 <= x <= len(nums):
        idx = x - 1
        if nums[idx] > 0:
            nums[idx] = -nums[idx]
missing = [i + 1 for i in range(len(nums)) if nums[i] > 0]
```

---

### Dutch National Flag (3-Way Partition)
> **Pattern:** Two Pointers | **Time:** O(n) | **Space:** O(1)
> **When:** partition array into three groups in one pass (e.g., sort colors 0/1/2)

```py
# WHY: Three regions grow inward: 0s from the left, 2s from the right, 1s in the
# middle. One pass with three pointers handles all cases.
low, mid, high = 0, 0, len(nums) - 1
while mid <= high:
    if nums[mid] == 0:
        nums[low], nums[mid] = nums[mid], nums[low]
        low += 1
        mid += 1
    elif nums[mid] == 1:
        mid += 1
    else:
        nums[mid], nums[high] = nums[high], nums[mid]
        high -= 1
```

---

### Quicksort (In-Place)
> **Pattern:** Divide and Conquer | **Time:** O(n log n) average | **Space:** O(log n) stack

```py
# WHY: In-place and cache-friendly. Average O(n log n) but O(n^2) worst case.
# Uses the same partition function from Step 40.
def quicksort(nums, lo=0, hi=None):
    if hi is None:
        hi = len(nums) - 1
    if lo >= hi:
        return
    p = partition(nums, lo, hi)  # partition() from Step 40
    quicksort(nums, lo, p - 1)
    quicksort(nums, p + 1, hi)
```

---

### Lowbit / Count Set Bits
> **Pattern:** Bit Manipulation | **Time:** O(bits) | **Space:** O(1)
> **When:** count how many bits are set, iterate only the on-bits

```py
# WHY: x & (x-1) clears the lowest set bit. This is faster than shifting through
# all 32 bits when only a few are set.
count = 0
while x:
    x &= x - 1  # clear lowest set bit
    count += 1
```

---

### Vector Cross Product (Orientation Test)
> **Pattern:** Math & Geometry | **Time:** O(1) | **Space:** O(1)
> **When:** left turn vs right turn, convex hull, polygon area

```py
# WHY: The sign of the 2D cross product tells you the turn direction.
# Positive = counter-clockwise (left turn), negative = clockwise (right turn).
def cross(ax, ay, bx, by):
    return ax * by - ay * bx
```

---

## GRAPH ALGORITHMS QUICK REFERENCE

| Algorithm | One-line definition | When to reach for it | Complexity |
|---|---|---|---|
| DFS | Go deep via stack/recursion, backtrack | Reachability, components, tree recursion | O(V+E) |
| BFS | Explore level-by-level via queue | Shortest path (unweighted), level order | O(V+E) |
| Topological Sort (Kahn) | Peel indegree-0 nodes in BFS layers | Dependency ordering, cycle detection in DAGs | O(V+E) |
| Union-Find (DSU) | Track components with find + union | Dynamic connectivity, redundant edges, MST | O(alpha(n)) per op |
| Dijkstra | Min-heap BFS on distance | Shortest path (non-negative weights) | O((V+E) log V) |
| 0-1 BFS | Deque: 0-weight to front, 1-weight to back | Shortest path when weights are 0 or 1 | O(V+E) |
| Kruskal | Sort edges + Union-Find, skip cycles | MST (sparse graph, edge list) | O(E log E) |
| Prim | Grow MST from one node via min-heap | MST (dense graph, adjacency list) | O((V+E) log V) |

---

## MEMORIZATION CHECKLIST

```
TIER 1 -- FOUNDATIONS
  Arrays & Hashing
    [ ] 1.  Frequency Count (Hash Map)
    [ ] 2.  Prefix Sum (1D)
    [ ] 3.  Prefix Sum + Hash Map (Subarray Sum = k)
  Two Pointers
    [ ] 4.  Two Pointers (Left/Right)
    [ ] 5.  Fast/Slow Pointers
  Sliding Window
    [ ] 6.  Sliding Window (Variable)
    [ ] 7.  Sliding Window (Fixed)
    [ ] 8.  Monotonic Queue (Window Max)
  Stack
    [ ] 9.  Stack Matching / Parsing
    [ ] 10. Monotonic Stack
  Binary Search
    [ ] 11. Lower Bound Binary Search
    [ ] 12. Binary Search on Answer

TIER 2 -- DATA STRUCTURES & RECURSION
  Linked List
    [ ] 13. Linked List Reverse
    [ ] 14. Merge Two Sorted Lists
  Trees
    [ ] 15. Tree DFS (Recursive)
    [ ] 16. Tree BFS (Level Order)
  Heap / Priority Queue
    [ ] 17. Min-Heap Top-K
    [ ] 18. K-Way Merge
    [ ] 19. Two Heaps (Median)
  Backtracking
    [ ] 20. Backtracking (Choose-Explore-Unchoose)
  Tries
    [ ] 21. Trie Insert / Search

TIER 3 -- GRAPHS
  Graphs
    [ ] 22. Graph BFS
    [ ] 23. Graph DFS
    [ ] 24. Grid BFS/DFS
    [ ] 25. Topological Sort (Kahn)
  Advanced Graphs
    [ ] 26. Union-Find (DSU)
    [ ] 27. Dijkstra
    [ ] 28. 0-1 BFS
    [ ] 29. Kruskal MST

TIER 4 -- STRATEGY & TOOLKITS
  Greedy
    [ ] 30. Greedy (Earliest Finish)
    [ ] 31. Greedy (Farthest Reach)
  Intervals
    [ ] 32. Interval Merge
    [ ] 33. Line Sweep
  Math & Geometry
    [ ] 34. GCD / LCM
    [ ] 35. Sieve of Eratosthenes
    [ ] 36. Fast Exponentiation
  Bit Manipulation
    [ ] 37. Bitmask Subsets
    [ ] 38. XOR Cancellation
  Divide & Conquer
    [ ] 39. Merge Sort
    [ ] 40. Quickselect

TIER 5 -- ADDITIONAL CORE TEMPLATES
  Design
    [ ] 41. LRU Cache (HashMap + Doubly Linked List)
  Strings
    [ ] 42. Rolling Hash (Rabin-Karp)
  Advanced Graphs
    [ ] 43. Bellman-Ford
```

For each step: (1) read the English until it clicks, (2) write the code from memory, (3) solve the practice problems cold.
