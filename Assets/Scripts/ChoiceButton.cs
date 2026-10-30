using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;

public class ChoiceButton : MonoBehaviour, IPointerEnterHandler, IPointerClickHandler, IPointerExitHandler, ISelectHandler, ISubmitHandler
{
    Button _button;
    TextMeshProUGUI _label;

    ButtonColorComponent _colorComponent;
    
    bool _isHovering;
    
    public int ChoiceIndex;

    private void Awake()
    {
        _button = GetComponent<Button>();
        _label = GetComponentInChildren<TextMeshProUGUI>();
        _colorComponent = GetComponent<ButtonColorComponent>();
        
        UpdateChoiceText(string.Empty);
    }

    public void OnSelect(BaseEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        InkManager.instance.ShowOutcomes(ChoiceIndex);
    }

    public void OnSubmit(BaseEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        InkManager.instance.SelectChoice(ChoiceIndex);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        _isHovering = true;
        if (!_button.IsInteractable()) return;

        InkManager.instance.ShowOutcomes(ChoiceIndex);
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (!_button.IsInteractable()) return;

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

    public void UpdateChoiceText(string text) => _label.text = text;

    public void UpdateColors(Color color)
    {
        _colorComponent.UpdateColors(color);
    }

    public void ResetColor()
    {
        _colorComponent.ResetColor();
    }
}