import React, { useState } from 'react';
import axios from 'axios';

export default function Home() {
  const [text, setText] = useState('');
  const [translation, setTranslation] = useState('');
  const [highlighted, setHighlighted] = useState('');

  const handleWordClick = async (word) => {
    setHighlighted(word);
    const res = await axios.get(`/api/translate?word=${encodeURIComponent(word)}`);
    setTranslation(res.data.translation);
  };

  return (
    <div style={{maxWidth:800, margin:'40px auto', fontFamily:'Arial'}}>
      <h1>LinguaReader Web — German → Spanish</h1>
      <textarea placeholder="Pega texto en alemán aquí" rows={6} style={{width:'100%'}} value={text} onChange={e=>setText(e.target.value)} />
      <p style={{lineHeight:1.6, marginTop:20}}>
        {text.split(/(\s+)/).map((word, i) => (
          <span key={i} style={{background: word.trim() === highlighted ? '#ffe58a' : 'transparent', cursor:'pointer'}} onClick={()=>handleWordClick(word.trim())}>
            {word}
          </span>
        ))}
      </p>
      <div style={{marginTop:20, padding:12, border:'1px solid #ddd', borderRadius:8}}>
        <strong>Traducción:</strong>
        <div style={{marginTop:8}}>{translation}</div>
      </div>
    </div>
  );
}
