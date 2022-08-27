using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.Networking;

public class AudioManager : MonoBehaviour
{
    [SerializeField] List<AudioClip> m_allAudioBits;
    AudioSource m_audioSource;

    #region SINGLETON
    private static AudioManager _instance;
    public static AudioManager instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<AudioManager>();
                if (_instance == null)
                {
                    GameObject go = new GameObject();
                    go.name = "[AudioManager]";
                    _instance = go.AddComponent<AudioManager>();
                    DontDestroyOnLoad(go);
                }
            }
            return _instance;
        }
    }

    void Awake()
    {
        if (_instance == null)
        {
            _instance = this;
            DontDestroyOnLoad(this.gameObject);

            m_audioSource = GetComponent<AudioSource>();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    #endregion

    void Start()
    {
        // Collect all the .mp3, .ogg and .wav files in the StreamingAssets folder
        IEnumerable<string> allSFXpaths = Directory.EnumerateFiles($"{Application.streamingAssetsPath}/SFX", "*.*", SearchOption.AllDirectories).Where(x =>
            x.EndsWith(".mp3", StringComparison.OrdinalIgnoreCase) ||
            x.EndsWith(".ogg", StringComparison.OrdinalIgnoreCase) ||
            x.EndsWith(".wav", StringComparison.OrdinalIgnoreCase)
            );

        // Import each of them into the game
        foreach (string path in allSFXpaths)
        {
            StartCoroutine(LoadAudioClip($"file:///{path}"));
        }
    }

    /// <summary>
    /// Imports AudioClips from file at the given path
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    IEnumerator LoadAudioClip(string path)
    {
        AudioType type = AudioType.UNKNOWN;
        
        if (path.EndsWith(".ogg", StringComparison.OrdinalIgnoreCase)) type = AudioType.OGGVORBIS;
        if (path.EndsWith(".wav", StringComparison.OrdinalIgnoreCase)) type = AudioType.WAV;
        if (path.EndsWith(".mp3", StringComparison.OrdinalIgnoreCase)) type = AudioType.MPEG;

        using (UnityWebRequest www = UnityWebRequestMultimedia.GetAudioClip(path, type))
        {
            yield return www.SendWebRequest();

            if (www.result == UnityWebRequest.Result.ProtocolError || www.result == UnityWebRequest.Result.ConnectionError)
            {
                Debug.Log(www.error);
            }
            else
            {
                AudioClip myClip = DownloadHandlerAudioClip.GetContent(www);
                myClip.name = Path.GetFileNameWithoutExtension(path);
                m_allAudioBits.Add(myClip);
            }
        }
    }

    /// <summary>
    /// Get an AudioClip by its name
    /// </summary>
    /// <param name="clipName"></param>
    /// <returns></returns>
    AudioClip GetAudioClip(string clipName) => m_allAudioBits.Find(x => x.name.Equals(clipName));

    /// <summary>
    /// Play an AudioClip once
    /// </summary>
    /// <param name="clipName"></param>
    public void PlayOneShot(string clipName)
    {
        AudioClip clip = GetAudioClip(clipName);
        
        if (clip != null)
        {
            m_audioSource.PlayOneShot(clip);
        }
    }

    /// <summary>
    /// Play an AudioClip on loop
    /// </summary>
    /// <param name="clipName"></param>
    public void Play(string clipName)
    {
        AudioClip clip = GetAudioClip(clipName);

        if (clip != null)
        {
            m_audioSource.clip = clip;
            m_audioSource.Play();
        }
    }

    public void Stop(string clipName)
    {
        AudioClip clip = GetAudioClip(clipName);

        if (clip != null)
        {
            if (m_audioSource.clip == clip)
            {
                m_audioSource.Stop();
            }
        }
    }

    /// <summary>
    /// Stops all AudioSources
    /// </summary>
    /// <param name="clipName"></param>
    public void StopAllClips()
    {
        m_audioSource.Stop();
    }
}
