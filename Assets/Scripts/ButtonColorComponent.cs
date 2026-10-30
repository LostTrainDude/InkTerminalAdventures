using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ButtonColorComponent : MonoBehaviour, IPointerEnterHandler, IPointerClickHandler, IPointerExitHandler
{
    bool _isHovering;

    Button _button;
    Image _image;
    TextMeshProUGUI _label;

    public Color32 ContainerHighlightedColor;
    public Color32 ContainerNormalColor;

    public Color32 LabelHighlightedTextColor;
    public Color32 LabelNormalTextColor;

    private void Awake()
    {
        _button = GetComponent<Button>();
        _image = GetComponent<Image>();
        _label = GetComponentInChildren<TextMeshProUGUI>();
    }

    public virtual void OnPointerEnter(PointerEventData eventData)
    {
        _isHovering = true;
        if (!_button.IsInteractable()) return;
    }

    public virtual void OnPointerClick(PointerEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        _image.color = ContainerNormalColor;
        _label.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);
    }

    public virtual void OnPointerExit(PointerEventData eventData)
    {
        _isHovering = false;
        if (!_button.IsInteractable()) return;
    }

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
        _label.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);
    }

    private void LateUpdate()
    {
        // Keep the visual feedback consistent after clicking
        // if the cursor is still hovering the button
        if (_isHovering && _button.IsInteractable())
        {
            _image.color = ContainerHighlightedColor;
            _label.color = new Color32(LabelHighlightedTextColor.r, LabelHighlightedTextColor.g, LabelHighlightedTextColor.b, LabelHighlightedTextColor.a);
        }
        else
        {
            _image.color = ContainerNormalColor;
            _label.color = new Color32(LabelNormalTextColor.r, LabelNormalTextColor.g, LabelNormalTextColor.b, LabelNormalTextColor.a);
        }
    }
}