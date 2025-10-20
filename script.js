// Simple calculator logic
(() => {
  const display = document.getElementById('display');
  const buttons = document.querySelectorAll('.btn');

  let current = '0';
  let lastWasEval = false;

  function isOperator(ch) {
    return ['+', '−', '-', '×', '÷', '*', '/', '%'].includes(ch);
  }

  function updateDisplay() {
    display.textContent = current || '0';
  }

  function appendValue(val) {
    if (lastWasEval) {
      // start new expression when a number is pressed after evaluation
      if (!isOperator(val)) {
        current = val === '.' ? '0.' : val;
        lastWasEval = false;
        return updateDisplay();
      }
      lastWasEval = false;
    }

    // Prevent multiple leading zeros
    if (current === '0' && val !== '.' && !isOperator(val)) {
      current = val;
      return updateDisplay();
    }

    // Prevent multiple dots in a number
    if (val === '.') {
      // find last operator position
      const lastOp = Math.max(
        ...['+', '-', '−', '×', '÷', '*', '/', '%'].map(op => current.lastIndexOf(op))
      );
      const lastNumber = current.slice(lastOp + 1);
      if (lastNumber.includes('.')) return;
    }

    // Prevent two operators in a row (replace last operator)
    if (isOperator(val)) {
      if (isOperator(current.slice(-1))) {
        current = current.slice(0, -1) + val;
        return updateDisplay();
      }
    }

    current += val;
    updateDisplay();
  }

  function clearAll() {
    current = '0';
    lastWasEval = false;
    updateDisplay();
  }

  function backspace() {
    if (lastWasEval) {
      current = '0';
      lastWasEval = false;
      return updateDisplay();
    }
    if (current.length <= 1) {
      current = '0';
    } else {
      current = current.slice(0, -1);
    }
    updateDisplay();
  }

  function evaluateExpression() {
    // Replace calculator symbols with JS operators
    let expr = current.replace(/×/g, '*').replace(/÷/g, '/').replace(/−/g, '-');

    // Basic safety: only allow digits, operators, parentheses, dot, and spaces
    if (!/^[0-9+\-*/%.() ]+$/.test(expr)) {
      display.textContent = 'Error';
      current = '0';
      return;
    }

    // Prevent trailing operator
    if (isOperator(expr.slice(-1))) {
      expr = expr.slice(0, -1);
    }

    try {
      // Use Function to avoid eval in some contexts (still executes JS)
      const result = Function(`"use strict"; return (${expr})`)();
      // Normalize result (avoid long floats)
      const formatted = Number.isFinite(result) ? parseFloat(result.toPrecision(12)).toString() : 'Error';
      current = formatted;
      updateDisplay();
      lastWasEval = true;
    } catch (e) {
      display.textContent = 'Error';
      current = '0';
    }
  }

  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      const action = btn.dataset.action;
      const val = btn.dataset.value;

      if (action === 'clear') return clearAll();
      if (action === 'back') return backspace();
      if (action === 'equals') return evaluateExpression();
      if (val) return appendValue(val);
    });
  });

  // Keyboard support
  window.addEventListener('keydown', (e) => {
    const key = e.key;

    if ((key >= '0' && key <= '9') || key === '.') {
      appendValue(key);
      e.preventDefault();
      return;
    }

    if (key === 'Enter' || key === '=') {
      evaluateExpression();
      e.preventDefault();
      return;
    }

    if (key === 'Backspace') {
      backspace();
      e.preventDefault();
      return;
    }

    if (key === 'Escape' || key === 'c' || key === 'C') {
      clearAll();
      e.preventDefault();
      return;
    }

    if (key === '+' || key === '-' || key === '*' || key === '/' || key === '%') {
      // map * and / to same characters; display uses × and ÷ but we accept JS symbols
      const map = {'*':'×','/':'÷'};
      const displayOp = map[key] || key;
      appendValue(displayOp);
      e.preventDefault();
      return;
    }
  });

  // Initialize
  updateDisplay();
})();
