import axios from 'axios';

export default async function handler(req, res) {
  const { word } = req.query;
  const apiKey = process.env.PONS_API_KEY || '';
  try {
    const ponsRes = await axios.get(`https://api.pons.com/v1/dictionary?q=${encodeURIComponent(word)}&l=deen`, {
      headers: {
        'X-Secret': apiKey,
        'Accept': 'application/json'
      }
    });
    const data = ponsRes.data;
    const translation = data?.[0]?.hits?.[0]?.roms?.[0]?.headword || '[untranslated]';
    res.status(200).json({ translation });
  } catch (e) {
    res.status(500).json({ translation: '[error]' });
  }
}
