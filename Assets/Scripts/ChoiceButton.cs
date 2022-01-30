using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ChoiceButton : MonoBehaviour, IPointerEnterHandler, IPointerClickHandler, IPointerExitHandler
{
    public int ChoiceIndex;

    Button _button;
    Image _image;
    TextMeshProUGUI _choiceText;

    public Color32 ContainerHighlightedColor;
    public Color32 ContainerNormalColor;

    public Color32 LabelHighlightedTextColor;
    public Color32 LabelNormalTextColor;

    bool _isHovering;

    private void Awake()
    {
        _button = GetComponent<Button>();
        _image = GetComponent<Image>();
        _choiceText = GetComponentInChildren<TextMeshProUGUI>();

        UpdateChoiceText(string.Empty);
    }

    public void OnSelect(BaseEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("hover");
        InkManager.instance.ShowOutcomes(ChoiceIndex);
    }

    public void OnSubmit(BaseEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("click");
        InkManager.instance.SelectChoice(ChoiceIndex);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        _isHovering = true;
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("hover");
        InkManager.instance.ShowOutcomes(ChoiceIndex);
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("click");

        _image.color = ContainerNormalColor;
        _choiceText.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);

        InkManager.instance.SelectChoice(ChoiceIndex);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        _isHovering = false;
        if (!_button.IsInteractable()) return;
        
        InkManager.instance.HideOutcomes();
    }

    /// <summary>
    /// Switches the button on
    /// </summary>
    public void TurnOn()
    {
        _button.interactable = true;
        
        // If the cursor is still over the button
        // show the available outcomes for the given choice
        if (_isHovering) InkManager.instance.ShowOutcomes(ChoiceIndex);
    }


    /// <summary>
    /// Switches the button off, removing text from its label
    /// </summary>
    public void TurnOff()
    {
        _button.interactable = false;
        UpdateChoiceText(string.Empty);
    }

    public void UpdateChoiceText(string text) => _choiceText.text = text;

    /// <summary>
    /// Changes the palette for the button
    /// </summary>
    /// <param name="color"></param>
    public void UpdateColors(Color color)
    {
        LabelNormalTextColor = color;
        ContainerHighlightedColor = color;
    }

    /// <summary>
    /// Resets the layout to its normal state
    /// </summary>
    public void ResetColor()
    {
        _image.color = ContainerNormalColor;
        _choiceText.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);
    }

    private void LateUpdate()
    {
        // Keep the visual feedback consistent after clicking
        // if the cursor is still hovering the button
        if (_isHovering && _button.IsInteractable())
        {
            _image.color = ContainerHighlightedColor;
            _choiceText.color = new Color32(LabelHighlightedTextColor.r, LabelHighlightedTextColor.g, LabelHighlightedTextColor.b, LabelHighlightedTextColor.a);
        }
        else
        {
            _image.color = ContainerNormalColor;
            _choiceText.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);
        }
    }
}
