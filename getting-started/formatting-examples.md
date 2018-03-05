# The title

{% objectives "Learning Objectives" %}
* The starterkit lessons all start with objectives about the lesson
* Objective 2 with some *formatted* **text** ~~like~~ `this`
{% endobjectives %}

## Basic formatting

You can make **bold**, *italic* and ~~strikethrough~~ text.
Add relative links like [this one](README.md) and absolute links in a [couple](https://example.com) of [different][example_website] ways.

Have bulleted lists:

 - Point 1
 - Point 2
   - Sub point
    - Sub point
   - Sub point
 - Point 2

Use numbered lists:

 1. First
 2. Second
   1. Second first
     1. Second first first
   2. Second second
 3. Third

## LaTeX

You can use inline LaTeX maths such as talking about the decay $$D^{* +} \rightarrow \left( D^0 \rightarrow K^{-} \pi^{+} \right)$$.

## Code highlighting

And have small lines of code inline like saying `print("Hello world")` or have multiple lines with syntax highlighting for python:

```python
import sys

def stderr_print(string):
    sys.stderr.write(string)

stderr_print("Hello world")
```

bash:

```bash
lb-run Bender/latest $SHELL
dst_dump -f -n 100 my_file.dst 2>&1 | tee log.log
```

and more!


<!-- All these lines are commented out

```python
print("Hello world")
```
 -->

## Callouts

{% prereq "Prequisites" %}
* Prequisite 1
* Prequisite 2
{% endprereq %}

{% objectives "Objectives" %}
* Objective 1
* Objective 2
{% endobjectives %}

{% challenge "Challenge" %}
Set a challenge here, and the solution will remain hidden until it's clicked
 - How to print?
{% solution "Solution" %}
The answer is:

```python
print("Hello world")
```
{% endchallenge %}

{% discussion "Extra details that are hidden by default" %}
Some extra details
{% enddiscussion %}

{% keypoints "Keypoints" %}
* Summary point 1
* Summary point 2
{% endkeypoints %}

## Quotes

> This was said by someone

## Tables

Simple tables are possible

First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column

## Images

![alt image text](https://lhcb.github.io/starterkit/img/starterkit.png)

## Section types

This is a section

### Subsections

And a subsection

#### Subsubsections

And a subsubsection


[example_website]: https://www.example.com
