using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UILabel : MonoBehaviour
{
    Image _image;

    public Color32 ContainerHighlightedColor;
    public Color32 ContainerNormalColor;

    public Color32 LabelHighlightedTextColor;
    public Color32 LabelNormalTextColor;

    TextMeshProUGUI _label;

    private void Awake()
    {
        _image = GetComponent<Image>();
        _label = GetComponentInChildren<TextMeshProUGUI>();

        UpdateLabel(string.Empty);
    }
    
    public void Highlight()
    {
        _image.color = ContainerHighlightedColor;
        _label.color = new Color32(LabelHighlightedTextColor.r, LabelHighlightedTextColor.g, LabelHighlightedTextColor.b, LabelHighlightedTextColor.a);
    }

    public void ResetColor()
    {
        _image.color = ContainerNormalColor;
        _label.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);
    }

    public void UpdateColors(Color color)
    {
        ContainerNormalColor = color;
        LabelHighlightedTextColor = color;
    }

    public void UpdateLabel(string text) => _label.text = text;
}
