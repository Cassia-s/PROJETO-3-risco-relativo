import streamlit as st
import numpy as np

# --- Função para formatar moeda estilo brasileiro ---
def formatar_moeda(valor):
    return f"R$ {valor:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

# --- Configuração da página ---
st.set_page_config(page_title="Calculadora de Risco de Crédito - Super Caja", layout="centered")

st.title("💸 Calculadora de Risco de Crédito - Super Caja")

st.markdown("""
Preencha os dados do cliente abaixo para uma **análise de risco de crédito**.  
Nosso sistema estima a probabilidade do cliente ser um **Bom Pagador**, **Intermediário** ou **Mau Pagador**.
""")

# --- Entradas do Usuário ---
st.header("👤 Dados do Cliente")
col1, col2 = st.columns(2)

with col1:
    salario = st.number_input("💵 Salário mensal (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)
    dependentes = st.number_input("👨‍👩‍👧‍👦 Número de dependentes", min_value=0, step=1, value=0)
    dividas_mensais = st.number_input("📉 Total de dívidas mensais (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)

with col2:
    limite_credito = st.number_input("💳 Limite total de crédito disponível (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)
    uso_credito = st.number_input("📊 Uso atual do crédito (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)
    emprestimos_ativos = st.number_input("🏦 Quantidade de empréstimos ativos", min_value=0, step=1, value=0)

st.subheader("🗓️ Histórico de Atrasos")
st.markdown("Informe o número de atrasos por período:")
atrasos_30 = st.number_input("Atrasos < 30 dias", min_value=0, step=1, value=0)
atrasos_60 = st.number_input("Atrasos 60 dias", min_value=0, step=1, value=0)
atrasos_90_mais = st.number_input("Atrasos 90+ dias", min_value=0, step=1, value=0)

# --- Cálculos ---
# Atrasos ponderados com pesos
total_atrasos_ponderado = (atrasos_30 * 0.5) + (atrasos_60 * 1.0) + (atrasos_90_mais * 2.0)

# Proteções com valores padrão conservadores
salario_por_dependente = salario / dependentes if dependentes > 0 else (salario if salario > 0 else 500.0)
media_debt_ratio = dividas_mensais / salario if salario > 0 else 1.0
media_uso_linhas_credito = uso_credito / limite_credito if limite_credito > 0 else 1.0

# Índice de risco agora sempre tem influência
indice_risco_credito = 1 + total_atrasos_ponderado / (1 + uso_credito / 1000)
peso_emprestimos = emprestimos_ativos * 0.5

# Score total com pesos ajustados
score_total = (
    (indice_risco_credito * 2.0) +
    (0.5 / (salario_por_dependente / 1000)) +
    (media_debt_ratio * 3.0) +
    (media_uso_linhas_credito * 1.5) +
    peso_emprestimos
)

# Normalizar o score para entre 1 e 10
score_total = max(1.0, min(10.0, score_total / 2.5))

# --- Exibir Resultados ---
st.header("📊 Resultado da Análise")
st.metric(label="📈 Score de Risco Total", value=f"{score_total:.2f}")

# Classificação de risco
if score_total <= 6:
    st.success("✅ **Resultado: Bom Pagador**")
elif 6 < score_total <= 8:
    st.warning("⚠️ **Resultado: Intermediário**")
elif score_total > 8.0:
    st.error("🚩 **Resultado: Mau Pagador**")

# Resumo formatado
st.markdown("### 💡 Resumo dos Dados Informados")
st.markdown(f"- **Salário:** {formatar_moeda(salario)}")
st.markdown(f"- **Dívidas mensais:** {formatar_moeda(dividas_mensais)}")
st.markdown(f"- **Limite de crédito:** {formatar_moeda(limite_credito)}")
st.markdown(f"- **Uso atual do crédito:** {formatar_moeda(uso_credito)}")
st.markdown(f"- **Dependentes:** {dependentes}")
st.markdown(f"- **Empréstimos ativos:** {emprestimos_ativos}")
st.markdown(f"- **Atrasos (<30 / 30-90 / 90+):** {atrasos_30} / {atrasos_60} / {atrasos_90_mais}")

st.markdown("---")

# --- Explicação dos critérios ---
with st.expander("ℹ️ Entenda como o score é calculado"):
    st.markdown("""
O **Score de Risco Total** avalia a probabilidade de inadimplência com base em:

- **Histórico de Atrasos:** Atrasos longos impactam mais o score.
- **Salário por Dependente:** Renda disponível por pessoa da família.
- **Dívidas sobre salário:** Quanto maior a proporção, maior o risco.
- **Uso do Crédito:** Quanto mais perto do limite, maior o risco.
- **Empréstimos Ativos:** Muitos empréstimos elevam o risco.

**Faixas de Score:**
- **1 a 6:** Bom Pagador  
- **7 a 8:** Intermediário  
- **8,5 a 10:** Mau Pagador

> ⚠️ Este é um modelo demonstrativo. Um sistema real usaria aprendizado de máquina com milhares de registros.
""")

st.markdown("---")
st.info("Desenvolvido para Super Caja com ❤️ usando Streamlit")



