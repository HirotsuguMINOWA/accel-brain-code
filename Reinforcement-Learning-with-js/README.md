# Reinforcement Learning with JavaScript

These JavaScript modules are library to implement Reinforcement Learning, especially for Q-Learning.

## Description

These modules are functionally equivalent to Python Scripts in [pyqlearning](https://github.com/chimera0/accel-brain-code/tree/master/Reinforcement-Learning). Considering many variable parts and functional extensions in the Q-learning paradigm, I implemented these scripts for demonstrations of *commonality/variability analysis* in order to design the models.

## Installation

### Source code

The source code is currently hosted on GitHub.

- [accel-brain-code/Reinforcement-Learning-with-js](https://github.com/chimera0/accel-brain-code/tree/master/Reinforcement-Learning-with-js)

## Demonstration: Autocompletion

- [Autocompletion system.](https://accel-brain.com/cardbox/demo_autocompletion.html)
- [accel-brain-code/Cardbox](https://github.com/chimera0/accel-brain-code/tree/master/Cardbox)

### Code sample

The function of autocompletion is a kind of natural language processing. Load follow JavaScript files in [devsample](devsample/). These scripts are functionally equivalent to Python Scripts in [pysummarization](https://github.com/chimera0/accel-brain-code/tree/master/Automatic-Summarization).

```
<script type="text/javascript" src="devsample/nlpbase.js"></script>
<script type="text/javascript" src="devsample/ngram.js"></script>
```

The modules of autocompletion depend on [TinySegmenter](http://chasen.org/~taku/software/TinySegmenter/) (v0.2). Load this JavaScript file.

```
<script type="text/javascript" src="dependencies/tiny_segmenter-0.2.js"></script>
```

And `Q-Learning` modules are to be included.

```html
<script type="text/javascript" src="jsqlearning/qlearning.js"></script>
<script type="text/javascript" src="jsqlearning/qlearning/boltzmann.js"></script>
<script type="text/javascript" src="jsqlearning/qlearning/boltzmann/autocompletion.js"></script>
```

If you want to use not `Boltzmann-Distribution-Q-Learning` but `Epsilon-Greedy-Q-Learning`, include follow files instead.

```html
<script type="text/javascript" src="jsqlearning/qlearning.js"></script>
<script type="text/javascript" src="jsqlearning/qlearning/greedy.js"></script>
<script type="text/javascript" src="jsqlearning/qlearning/greedy/autocompletion.js"></script>
```

Initialize NLP modules.

```js
// The number of n-gram.
var n = 2;
// The function of n-gram.
var n_gram = new Ngram();
// Base class of NLP for tokenization.
var nlp_base = new NlpBase();

// The function of autocompletion algorithm.
var autocompletion = new Autocompletion(
    nlp_base,
    n_gram,
    n
);
```

Setup hyperparameters in `Boltzmann-Distribution-Q-Learning`.

```js
// Time rate in boltzmann distribution.
taime_rate = 0.001;

// The algorithm of boltzmann distribution.
var strategy = new Boltzmann(
    autocompletion,
    {
        "time_rate": time_rate
    }
);
```

If you want to use `Epsilon-Greedy-Q-Learning`, setup the epsilon-greedy-rate instead.

```js
// The epsilon greedy rate.
epsilon_greedy_rate = 0.75;

// The algorithm of epsilon-greedy.
var strategy = new Greedy(
    autocompletion,
    {
        "epsilon_greedy_rate": epsilon_greedy_rate
    }
);
```

And, setup common hyperparameters in `Q-Learning` and initialize.

```
// Alpha value in Q-Learning algorithm.
alpha_value = 0.5;
// Gamma value in Q-Learning algorithm.
gamma_value = 0.5;
// The number of learning.
limit = 10000;

// Base class of Q-Learning.
var q_learning = new QLearning(
    strategy,
    {
        "alpha_value": alpha_value,
        "gamma_value": gamma_value
    }
);

```

Set learned data.

```js
// Learned data.
first_learned_data = "hogehogehogefugafuga";

// Pre training for first user's typing.
autocompletion_.pre_training(
    q_learning,
    first_learned_data
);
```

Execute recursive learning in loop control structure or recursive call.

```js
// User's typing.
input_document = "hogefuga";

// Extract state in input_document.
var state_key = autocompletion.lap_extract_ngram(
    q_learning,
    input_document
);

// Learning.
q_learning.learn(state_key, limit);

// Predict next token.
var next_action_list = q_learning.extract_possible_actions(
    state_key
);
var action_key = q_learning.select_action(
    state_key,
    next_action_list
);

// Compute reward value.
var reward_value = q_learning.observe_reward_value(
    state_key,
    action_key
);

// Compute Q-Value.
var q_value = q_learning.extract_q_dict(
    state_key,
    action_key
);

// Pre training for next user's typing.
autocompletion_.pre_training(
    q_learning,
    input_document
);
```

## Related PoC

- [深層強化学習のベイズ主義的な情報探索に駆動された自然言語処理の意味論](https://accel-brain.com/semantics-of-natural-language-processing-driven-by-bayesian-information-search-by-deep-reinforcement-learning/) (Japanese)
    - [バンディットアルゴリズムの機能的拡張としての強化学習アルゴリズム](https://accel-brain.com/semantics-of-natural-language-processing-driven-by-bayesian-information-search-by-deep-reinforcement-learning/verstarkungslernalgorithmus-als-funktionale-erweiterung-des-banditenalgorithmus/)
    - [深層強化学習の統計的機械学習、強化学習の関数近似器としての深層学習](https://accel-brain.com/semantics-of-natural-language-processing-driven-by-bayesian-information-search-by-deep-reinforcement-learning/deep-learning-als-funktionsapproximator-fur-verstarktes-lernen/)
- [「人工の理想」を背景とした「万物照応」のデータモデリング](https://accel-brain.com/data-modeling-von-korrespondenz-in-artificial-paradise) (Japanese)
    - [「万物照応」のデータモデリング](https://accel-brain.com/data-modeling-von-korrespondenz-in-artificial-paradise/datenmodellierung-fur-korrespondenz/)

## Version

- 1.0.1

## Author

- chimera0(RUM)

## Author URI

- [http://accel-brain.com/](http://accel-brain.com/)

## License

- GNU General Public License v2.0
