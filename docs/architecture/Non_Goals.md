# IPC-100 Rev A Non-Goals

| Document control | Value |
| --- | --- |
| Document title | IPC-100 Rev A Non-Goals |
| Purpose | Define explicit exclusions that constrain Rev A scope |
| Revision | Blueprint v1.0 |
| Status | Draft |
| Last updated | TBD |
| Author | TBD |

## 1. Purpose

This document reduces scope creep by recording what IPC-100 Rev A is not intended to provide. A non-goal may change only through documented architecture and requirements review.

## 2. Electrical and power non-goals

IPC-100 Rev A is:

- Not a motor driver
- Not a carrier for motor current
- Not a high-current power-distribution board
- Not a battery charger
- Not a battery-management system
- Not a solar charge controller
- Not a universal DC power converter for product loads
- Not responsible for product-level fusing or branch protection

## 3. Product non-goals

IPC-100 Rev A is:

- Not CrossWind or any other product
- Not responsible for product mechanics
- Not responsible for battery mounting
- Not responsible for motor, gearbox, linkage, or thrower selection
- Not responsible for product harness dimensions or routing
- Not responsible for product enclosure or user-panel design
- Not responsible for product-specific application behavior

## 4. Safety non-goals

IPC-100 does not replace product-level safety systems, risk analysis, accessible physical controls, independent high-current protection, mechanical guards, or safe installation practices.

Platform safe defaults and diagnostics support product safety, but they do not establish that a complete product is safe.

## 5. Environmental non-goals

- The bare PCB is not claimed to be IP65 or weatherproof.
- IPC-100 does not define the final product enclosure.
- IPC-100 does not control product condensation, drainage, cable-entry, or UV-exposure design.
- Rev A does not claim an operating-temperature range until it is approved and verified.

## 6. Scope-control questions

Before adding a proposed feature, reviewers should ask:

1. Is it required by more than one credible product?
2. Is it reusable without product-specific assumptions?
3. Does it preserve power, GPIO, thermal, and mechanical margins?
4. Can it be tested at controller level?
5. Does it belong on a daughterboard or in a product repository instead?
6. Is its lifecycle cost justified?

## 7. Related documents

- [Product Boundaries](Product_Boundaries.md)
- [System Architecture](System_Architecture.md)
- [Design Philosophy](Design_Philosophy.md)
- [Hardware Requirements](../requirements/Hardware_Requirements.md)
